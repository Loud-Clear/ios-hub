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

@implementation CCTableFormCell

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
    [self updateActionBarNavigationControl];
}

- (void)updateActionBarNavigationControl
{
    [self.actionBar.navigationControl setEnabled:[self indexPathForPreviousResponder] != nil forSegmentAtIndex:0];
    [self.actionBar.navigationControl setEnabled:[self indexPathForNextResponder] != nil forSegmentAtIndex:1];
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
            if ([class canFocusWithItem:item])
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
            if ([class canFocusWithItem:item])
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

#pragma mark -
#pragma mark CCActionBar delegate

- (void)actionBar:(CCActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl
{
    NSIndexPath *indexPath = navigationControl.selectedSegmentIndex == 0 ? [self indexPathForPreviousResponder] : [self indexPathForNextResponder];
    if (indexPath) {
        CCTableFormCell *cell = (CCTableFormCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        if (!cell)
            [self.parentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        cell = (CCTableFormCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        [cell.responder becomeFirstResponder];
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

@end
