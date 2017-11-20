////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCMutableCollections.h"
#import "CCTableFormCell.h"
#import "CCNotificationUtils.h"
#import "CCTableFormManager.h"
#import "CCTableFormItem.h"
#import "CCFormRule.h"
#import "CCFormPostProcessor.h"
#import "NSError+CCTableFormManager.h"
#import "CCFormRule.h"
#import "CCObjectObserver.h"
#import "CCFormOutput.h"
#import "CCTableViewManager+Internal.h"
#import "CCMacroses.h"


@interface CCTableFormItem ()
@property (weak, nonatomic) id<CCFormOutput> output;
@end

@interface CCTableFormCell ()
@property (weak, nonatomic) id<CCFormOutput> output;
@end

@interface CCTableFormManager () <CCFormOutput, CCFormRuleRegistry>
@end


@implementation CCTableFormManager
{
    NSMutableArray *_fieldObservers;

    NSMutableDictionary *_onEditingChangeRules;
    NSMutableDictionary *_onEndEditingRules;
    NSMutableDictionary *_onValueChangeRules;

    id<CCFormRule> _currentRule;
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self) {
        //Default values for forms
        self.tableView.allowsSelection = NO;
        _fieldObservers = [NSMutableArray new];

        _onEditingChangeRules = [NSMutableDictionary new];
        _onEndEditingRules = [NSMutableDictionary new];
        _onValueChangeRules = [NSMutableDictionary new];

        self.shouldValidateBeforeSubmit = YES;
        self.shouldUseDelegateToPresentValidationErrors = NO;
        self.shouldValidateFieldOnEndEditing = YES;

        [self registerForNotification:UITextFieldTextDidEndEditingNotification selector:@selector(onEndEditing:)];
        [self registerForNotification:UITextViewTextDidEndEditingNotification selector:@selector(onEndEditing:)];

        [self registerForNotification:UITextFieldTextDidChangeNotification selector:@selector(onChangeEditing:)];
        [self registerForNotification:UITextViewTextDidChangeNotification selector:@selector(onChangeEditing:)];

    }
    return self;
}

- (void)onEndEditing:(NSNotification *)notification
{
    UIView *object = notification.object;

    CCTableFormItem *item = [self itemFromCellSubview:object];
    if (item) {
        [self onChangeValueForName:item.name];

        if (self.shouldValidateFieldOnEndEditing) {
            [self validateFieldWithName:item.name];
        }

        if ([self.formDelegate respondsToSelector:@selector(formManager:didEndEditingFieldWithName:)]) {
            [self.formDelegate formManager:self didEndEditingFieldWithName:item.name];
        }
    }
}

- (void)onChangeEditing:(NSNotification *)notification
{
    CCTableFormItem *item = [self itemFromCellSubview:notification.object];

    if (item) {
        [self onTextChangeForName:item.name];

        if ([self.formDelegate respondsToSelector:@selector(formManager:didChangeEditingFieldWithName:)]) {
            [self.formDelegate formManager:self didChangeEditingFieldWithName:item.name];
        }
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Data
//-------------------------------------------------------------------------------------------

- (NSDictionary<NSString *, id> *)formRawData
{
    NSMutableDictionary<NSString *, id> *data = [NSMutableDictionary new];

    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        NSString *name = item.name;
        id value = item.value ? : [NSNull null];
        if (name && value) {
            data[name] = value;
        }
    }];

    return data;
}

- (void)setFormData:(NSDictionary<NSString *, id> *)data
{
    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        if (item.name) {
            id value = data[item.name];
            if (value && ![value isKindOfClass:[NSNull class]]) {
                item.value = value;
            } else {
                item.value = nil;
            }
        }
    }];

    [self.tableView reloadData];
}

- (void)resetForm
{
    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        if (item.resetValue) {
            item.value = item.resetValue;
        } else {
            DDLogWarn(@"Can't find resetValue for %@", item);
        }
    }];

    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (NSDictionary<NSString *, id> *)formData
{
    NSMutableDictionary *mutableData = [[self formRawData] mutableDictionary];
    for (id<CCFormPostProcessor> postProcessor in self.formPostProcessors) {
        if ([postProcessor respondsToSelector:@selector(postProcessData:)]) {
            [postProcessor postProcessData:mutableData];
        }
    }
    return mutableData;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Validations
//-------------------------------------------------------------------------------------------

- (NSArray<NSError *> *)validationErrorsFromData:(NSDictionary<NSString *, id> *)data
{
    NSMutableArray<NSError *> *errors = [NSMutableArray new];
    for (id<CCFormPostProcessor> filter in self.formPostProcessors) {
        if ([filter respondsToSelector:@selector(validateData:error:)]) {
            NSError *validationError = nil;
            BOOL isValid = [filter validateData:data error:&validationError];
            if (!isValid && validationError) {
                [errors addObject:validationError];
            }
        }
    }
    return errors;
}

- (void)setValidationErrors:(NSDictionary<NSString *, NSString *> *)errors
{
    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        if (item.name && item.validationError != errors[item.name]) {
            item.validationError = errors[item.name];
        }
    }];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)validateFieldWithName:(NSString *)fieldName
{
    NSDictionary<NSString *, id> *data = [self formRawData];
    for (id<CCFormPostProcessor> filter in self.formPostProcessors) {
        if ([filter respondsToSelector:@selector(shouldValidateAfterEndEditingName:)] &&
                [filter respondsToSelector:@selector(validateData:error:)]) {
            if ([filter shouldValidateAfterEndEditingName:fieldName]) {
                NSError *validationError = nil;
                if (![filter validateData:data error:&validationError] && validationError) {
                    [self didFailWithValidationErrors:@[validationError]];
                    return;
                }
            }
        }
    }
}

- (BOOL)isValid
{
    return [[self validationErrorsFromData:[self formRawData]] count] == 0;
}

- (BOOL)validate
{
    NSArray *errors = [self validationErrorsFromData:[self formRawData]];

    if ([errors count] != 0) {
        [self didFailWithValidationErrors:errors];
    }

    return [errors count] == 0;
}

- (void)didFailWithValidationErrors:(NSArray<NSError *> *)errors
{
    if ([self.formDelegate respondsToSelector:@selector(formManager:didFailWithValidationErrors:)]) {
        [self.formDelegate formManager:self didFailWithValidationErrors:errors];
    }

    if (!self.shouldUseDelegateToPresentValidationErrors) {
        NSDictionary *errorMessages = [NSError errorNamesAndMessagesFromArray:errors];
        [self setValidationErrors:errorMessages];

    }
}

- (void)submit
{
    [self onSubmit];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Form Rules
//-------------------------------------------------------------------------------------------

- (void)setRules:(NSArray *)rules
{
    [self willChangeValueForKey:@"rules"];
    _rules = rules;
    [self didChangeValueForKey:@"rules"];

    [self registerRuleTriggers];
    [self updateObservationForRules];
}

- (void)registerRuleTriggers
{
    for (id<CCFormRule> rule in self.rules) {
        [self registerTriggersForRule:rule withBlock:^{
            [rule registerTriggersWith:self];
        }];
    }
}

- (void)updateObservationForRules
{
    DDLogInfo(@"Updating observation for Form Rules");
    [_fieldObservers removeAllObjects];

    NSSet *namesToObserve = [[NSSet alloc] initWithArray:[_onValueChangeRules allKeys]];

    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        if (item.name && [namesToObserve containsObject:item.name]) {
            CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:item observer:self];
            @weakify(self)
            NSString *name = item.name;
            [observer observeKeys:@[@"value"] withBlock:^{
                @strongify(self)
                [self onChangeValueForName:name];
            }];
            [_fieldObservers addObject:observer];
        }
    }];
}

- (void)registerTriggersForRule:(id<CCFormRule>)rule withBlock:(dispatch_block_t)block
{
    _currentRule = rule;
    CCSafeCall(block);
    _currentRule = nil;
}

- (void)addCurrentRuleToRegistry:(NSMutableDictionary *)registry withName:(NSString *)fieldName
{
    NSMutableArray *rules = registry[fieldName];
    if (!rules) {
        rules = [NSMutableArray new];
        registry[fieldName] = rules;
    }
    [rules addObject:_currentRule];
}

- (void)applyAllRulesIn:(NSMutableDictionary *)registry withName:(NSString *)fieldName
{
    NSMutableArray *rules = registry[fieldName];
    for (id<CCFormRule> rule in rules) {
        [rule applyRuleOn:self];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - CCFormRuleRegistry
//-------------------------------------------------------------------------------------------

- (void)applyOnValueChangeForField:(NSString *)fieldName
{
    [self addCurrentRuleToRegistry:_onValueChangeRules withName:fieldName];
}

- (void)applyOnEndEditingForField:(NSString *)fieldName
{
    [self addCurrentRuleToRegistry:_onEndEditingRules withName:fieldName];
}

- (void)applyOnEditingChangedForField:(NSString *)fieldName
{
    [self addCurrentRuleToRegistry:_onEditingChangeRules withName:fieldName];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Field items observation callbacks
//-------------------------------------------------------------------------------------------

- (void)onEndEditingForName:(NSString *)name
{
    [self applyAllRulesIn:_onEndEditingRules withName:name];
}

- (void)onChangeValueForName:(NSString *)changedName
{
    [self applyAllRulesIn:_onValueChangeRules withName:changedName];
}

- (void)onTextChangeForName:(NSString *)name
{
    [self applyAllRulesIn:_onEditingChangeRules withName:name];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Fields manipulations
//-------------------------------------------------------------------------------------------

- (id)fieldForName:(NSString *)name
{
    __block id result = nil;
    [self enumerateFormItemsWithBlock:^(CCTableFormItem *item, BOOL *stop) {
        if ([item.name isEqualToString:name]) {
            result = item;
            *stop = YES;
        }
    }];
    return result;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utils
//-------------------------------------------------------------------------------------------

- (void)enumerateFormItemsWithBlock:(void (^)(CCTableFormItem *item, BOOL *stop))block
{
    BOOL stop = NO;
    for (CCTableViewSection *section in self.sections) {
        for (CCTableViewItem *item in section.items) {
            if ([item isKindOfClass:[CCTableFormItem class]]) {
                CCSafeCall(block, (id) item, &stop);
                if (stop) {
                    break;
                }
            }
            if (stop) {
                break;
            }
        }
    }
}

- (CCTableFormItem *)itemFromCellSubview:(UIView *)subview
{
    if ([subview isKindOfClass:[UIView class]]) {

        UIView *view = subview;
        while (view && ![view isKindOfClass:[CCTableFormCell class]]) {
            view = [view superview];
        }
        if (view) {
            CCTableFormCell *cell = (id)view;
            CCTableFormItem *item = cell.item;

            return item;
        }
    }
    return nil;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Items and cells handling
//-------------------------------------------------------------------------------------------

- (void)gotNewItems:(NSArray *)items
{
    [super gotNewItems:items];

    for (CCTableFormItem *item in items) {
        if ([item isKindOfClass:[CCTableFormItem class]]) {
            item.output = self;
        }
    }

    [self updateObservationForRules];
}

- (void)didLoadCell:(CCTableViewCell *)cell
{
    [super didLoadCell:cell];

    if ([cell isKindOfClass:[CCTableFormCell class]]) {
        ((CCTableFormCell *) cell).output = self;
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - <CCFormOutput>
//-------------------------------------------------------------------------------------------

- (void)onSubmit
{
    if (self.shouldValidateBeforeSubmit && ![self validate]) {
        return;
    }

    if ([self.formDelegate respondsToSelector:@selector(formManager:didSumbitWithData:)]) {
        [self.formDelegate formManager:self didSumbitWithData:[self formData]];
    }
}

@end
