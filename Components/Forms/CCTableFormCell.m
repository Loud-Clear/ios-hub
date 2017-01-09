//
//  CCTableFormCell.m
//  iOS Hub
//
//  Created by Aleksey Garbarev on 01/12/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import "CCTableFormCell.h"
#import "CCTableViewManager.h"
#import "CCTableViewItem.h"
#import "CCTableFormItem.h"
#import "CCFormOutput.h"
#import "CCMacroses.h"

@interface CCTableFormCell()
@property (weak, nonatomic) id<CCFormOutput> output;
@end

@implementation CCTableFormCell {
    __weak UITextField *_managedTextField;
    UIReturnKeyType _nextKey;
    UIReturnKeyType _submitKey;
}

- (CCTableFormItem *)asItem
{
    return self.item;
}

+ (BOOL)canFocusWithItem:(CCTableViewItem *)item
{
    return NO;
}

- (void)cellDidLoad
{
    [super cellDidLoad];

    self.actionBar = [[CCActionBar alloc] initWithDelegate:self];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    [self updateNavigationActions];
}

- (void)updateNavigationActions
{
    [self.actionBar.navigationControl setEnabled:[self canGoBack] forSegmentAtIndex:0];
    [self.actionBar.navigationControl setEnabled:[self canGoNext] forSegmentAtIndex:1];

    _managedTextField.returnKeyType = [self canGoNext] ? _nextKey : _submitKey;
}

- (UIResponder *)responder
{
    return nil;
}

- (NSIndexPath *)indexPathForPreviousResponderInSectionIndex:(NSUInteger)sectionIndex
{
    CCTableViewSection *section = self.tableViewManager.sections[sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : section.items.count;
    for (NSInteger i = indexInSection - 1; i >= 0; i--) {
        CCTableViewItem *item = section.items[i];
        if ([item isKindOfClass:[CCTableViewItem class]]) {
            Class class = [self.tableViewManager classForCellAtIndexPath:item.indexPath];
            if ([class isSubclassOfClass:[CCTableFormCell class]] && [class canFocusWithItem:item])
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForPreviousResponder
{
    for (NSInteger i = self.sectionIndex; i >= 0; i--) {
        NSIndexPath *indexPath = [self indexPathForPreviousResponderInSectionIndex:i];
        if (indexPath)
            return indexPath;
    }
    return nil;
}

- (NSIndexPath *)indexPathForNextResponderInSectionIndex:(NSUInteger)sectionIndex
{
    CCTableViewSection *section = self.tableViewManager.sections[sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : -1;
    for (NSInteger i = indexInSection + 1; i < section.items.count; i++) {
        CCTableViewItem *item = section.items[i];
        if ([item isKindOfClass:[CCTableViewItem class]]) {
            Class class = [self.tableViewManager classForCellAtIndexPath:item.indexPath];
            if ([class isSubclassOfClass:[CCTableFormCell class]] && [class canFocusWithItem:item])
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForNextResponder
{
    for (NSInteger i = self.sectionIndex; i < self.tableViewManager.sections.count; i++) {
        NSIndexPath *indexPath = [self indexPathForNextResponderInSectionIndex:i];
        if (indexPath)
            return indexPath;
    }

    return nil;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Keyboard
//-------------------------------------------------------------------------------------------

- (void)setupReturnKeyFor:(UITextField *)textField next:(UIReturnKeyType)next submit:(UIReturnKeyType)submit
{
    if (_managedTextField) {
        DDLogWarn(@"Cell %@ already have textField %@ to manage return button", self, _managedTextField);
    }

    [textField addTarget:self action:@selector(cc_onKeyboardReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    textField.returnKeyType = [self canGoNext] ? next : submit;

    _managedTextField = textField;
    _nextKey = next;
    _submitKey = submit;
}

- (void)cc_onKeyboardReturn
{
    if ([self canGoNext]) {
        [self onNext];
    } else {
        [self onSubmit];
    }
}

- (BOOL)canGoNext
{
    return [self indexPathForNextResponder] != nil;
}

- (BOOL)canGoBack
{
    return [self indexPathForPreviousResponder] != nil;
}

- (void)onNext
{
    [self makeCellFirstResponderAtIndexPath:[self indexPathForNextResponder]];
}

- (void)onBack
{
    [self makeCellFirstResponderAtIndexPath:[self indexPathForPreviousResponder]];
}

- (void)onSubmit
{
    [self.output onSubmit];
    [self endEditing:YES];
}

#pragma mark -
#pragma mark CCActionBar delegate

- (void)actionBar:(CCActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl
{
    if (navigationControl.selectedSegmentIndex == 0) {
        [self onBack];
    } else {
        [self onNext];
    }

    if (self.asItem.actionBarNavButtonTapHandler)
        self.asItem.actionBarNavButtonTapHandler(self.asItem);
}

- (void)actionBar:(CCActionBar *)actionBar doneButtonPressed:(UIBarButtonItem *)doneButtonItem
{
    if (self.asItem.actionBarDoneButtonTapHandler)
        self.asItem.actionBarDoneButtonTapHandler(self.asItem);

    [self endEditing:YES];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utils
//-------------------------------------------------------------------------------------------

- (void)makeCellFirstResponderAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        CCTableFormCell *cell = (CCTableFormCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            [self.parentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop
                                                animated:NO];
        }
        cell = (CCTableFormCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        [cell.responder becomeFirstResponder];
    }
}

@end
