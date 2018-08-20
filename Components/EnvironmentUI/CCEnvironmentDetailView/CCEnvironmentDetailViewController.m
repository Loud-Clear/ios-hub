////////////////////////////////////////////////////////////////////////////////
//
//  LOUDCLEAR
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of LoudClear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <PureLayout/ALView+PureLayout.h>
#import "CCEnvironment.h"
#import "CCTableFormManager.h"
#import "CCMacroses.h"
#import "CCObjectObserver.h"
#import "CCEnvironmentDetailViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CCEnvironment+PresentingName.h"
#import "CCEnvironmentField.h"
#import "NSObject+TyphoonIntrospectionUtils.h"


@interface CCEnvironmentDetailViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CCTableFormManager *formManager;
@end

@implementation CCEnvironmentDetailViewController
{
    CCObjectObserver *_envObserver;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self addToolbar];
    
    self.tableView = [TPKeyboardAvoidingTableView new];
    [self.view addSubview:self.tableView];

    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolbar];


    self.formManager = [[CCTableFormManager alloc] initWithTableView:self.tableView];
    self.formManager.formDelegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTitle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)setEnvironment:(CCEnvironment *)environment
{
    _environment = environment;

    _envObserver = [[CCObjectObserver alloc] initWithObject:environment observer:self];
    [_envObserver observeKeys:[environment cc_titleNames] withAction:@selector(updateTitle)];

    [self setupItems];
}

- (void)setupItems
{
    [self.formManager removeAllSections];

    CCTableViewSection *section = [CCTableViewSection new];

    NSMutableOrderedSet *allProperties = [NSMutableOrderedSet orderedSetWithArray:[[self.environment class] allPropertyKeys]];
    [allProperties removeObject:CCSelectorToString(filename)];

    for (NSString *key in allProperties) {
        CCEnvironmentField *field = [CCEnvironmentField new];
        field.environment = self.environment;
        field.name = key;
        field.value = [self.environment valueForKey:key];

        TyphoonTypeDescriptor *type = [self.environment typhoonTypeForPropertyNamed:key];
        [field setupWithType:type];

        [section addItem:field];
    }

    [self.formManager addSection:section];
}

- (void)addToolbar
{
    self.toolbar = [UIToolbar new];
    self.toolbar.translucent = NO;
    [self.view addSubview:self.toolbar];

    [self.toolbar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.toolbar autoSetDimension:ALDimensionHeight toSize:50];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:NULL];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self action:@selector(onCancel)];


    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.titleLabel sizeToFit];

    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    self.toolbar.items = @[space, title, space, cancel];
}



- (void)updateTitle
{
    self.titleLabel.text = [NSString stringWithFormat:@"Edit '%@'", [self.environment cc_presentingName]];
    [self.titleLabel sizeToFit];
    [self.toolbar setNeedsLayout];
}


- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)formManager:(CCTableFormManager *)formManager didChangeEditingFieldWithName:(NSString *)fieldName
{
    CCSafeCallOnMain(^{
        CCTableFormItem *item = [formManager fieldForName:fieldName];
        [self.environment batchSave:^{
            DDLogDebug(@"Set value %@ for field %@", item.value, fieldName);
            [self.environment setValue:item.value forKey:fieldName];
        }];

    });
}

- (void)formManager:(CCTableFormManager *)formManager didSumbitWithData:(NSDictionary<NSString *, id> *)data
{
    [self.environment batchSave:^{
        [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [self.environment setValue:obj forKey:key];
        }];
    }];
}

@end
