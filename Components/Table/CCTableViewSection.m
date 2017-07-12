//
// CCTableViewSection.m
// CCTableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "CCTableViewSection.h"
#import "CCTableViewManager.h"
#import "NSString+CCTableViewManagerAdditions.h"
#import <float.h>
#import "CCTableViewItem.h"
#import "CCTableViewManager+Internal.h"


CGFloat const CCTableViewSectionHeaderHeightAutomatic = DBL_MAX;
CGFloat const CCTableViewSectionFooterHeightAutomatic = DBL_MAX;

@interface CCTableViewSection ()

@property (strong, readwrite, nonatomic) NSMutableArray *mutableItems;

@end

@implementation CCTableViewSection

#pragma mark -
#pragma mark Creating and Initializing Sections

+ (instancetype)section
{
    return [[self alloc] init];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _mutableItems = [[NSMutableArray alloc] init];
    _headerHeight = CCTableViewSectionHeaderHeightAutomatic;
    _footerHeight = CCTableViewSectionFooterHeightAutomatic;
    _cellTitlePadding = 5;

    return self;
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    self = [self init];
    if (!self) {
        return nil;
    }

    self.headerTitle = headerTitle;
    self.footerTitle = footerTitle;

    return self;
}

- (id)initWithHeaderView:(UIView *)headerView
{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (!self) {
        return nil;
    }

    self.headerView = headerView;
    self.footerView = footerView;

    return self;
}

#pragma mark -
#pragma mark Styling

- (CCTableViewCellStyle *)style
{
    return _style ? _style : self.tableViewManager.style;
}

#pragma mark -
#pragma mark Reading information

- (NSUInteger)index
{
    CCTableViewManager *tableViewManager = self.tableViewManager;
    return [tableViewManager.sections indexOfObject:self];
}

- (CGFloat)maximumTitleWidthWithFont:(UIFont *)font
{
    /** 
     CGFloat width = 0; - max width from all cell titles
     return width + self.cellTitlePadding;
    */
    return self.cellTitlePadding;
}

#pragma mark -
#pragma mark Managing items

- (NSArray *)items
{
    return self.mutableItems;
}

- (void)addItem:(id)item
{
    [self gotNewItems:@[item]];

    [self.mutableItems addObject:item];

    [self didChangeItemsSet];
}

- (void)addItemsFromArray:(NSArray *)array
{
    [self gotNewItems:array];

    [self.mutableItems addObjectsFromArray:array];

    [self didChangeItemsSet];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index
{
    [self gotNewItems:@[item]];

    [self.mutableItems insertObject:item atIndex:index];

    [self didChangeItemsSet];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes
{
    [self gotNewItems:items];

    [self.mutableItems insertObjects:items atIndexes:indexes];

    [self didChangeItemsSet];
}

- (void)removeItem:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObject:item inRange:range];

    [self didChangeItemsSet];
}

- (void)removeLastItem
{
    [self.mutableItems removeLastObject];

    [self didChangeItemsSet];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.mutableItems removeObjectAtIndex:index];

    [self didChangeItemsSet];
}

- (void)removeItem:(id)item
{
    [self.mutableItems removeObject:item];

    [self didChangeItemsSet];
}

- (void)removeAllItems
{
    [self.mutableItems removeAllObjects];

    [self didChangeItemsSet];
}

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObjectIdenticalTo:item inRange:range];

    [self didChangeItemsSet];
}

- (void)removeItemIdenticalTo:(id)item
{
    [self.mutableItems removeObjectIdenticalTo:item];

    [self didChangeItemsSet];
}

- (void)removeItemsInArray:(NSArray *)otherArray
{
    [self.mutableItems removeObjectsInArray:otherArray];

    [self didChangeItemsSet];
}

- (void)removeItemsInRange:(NSRange)range
{
    [self.mutableItems removeObjectsInRange:range];

    [self didChangeItemsSet];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableItems removeObjectsAtIndexes:indexes];

    [self didChangeItemsSet];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item
{
    [self gotNewItems:@[item]];

    [self.mutableItems replaceObjectAtIndex:index withObject:item];

    [self didChangeItemsSet];
}

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    [self gotNewItems:otherArray];

    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];

    [self didChangeItemsSet];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray
{
    [self gotNewItems:otherArray];

    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray];

    [self didChangeItemsSet];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items
{
    [self gotNewItems:items];

    [self.mutableItems replaceObjectsAtIndexes:indexes withObjects:items];

    [self didChangeItemsSet];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [self.mutableItems exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableItems sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [self.mutableItems sortUsingSelector:comparator];
}

#pragma mark -
#pragma mark Manipulating table view section

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewManager.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Items change callbacks and post processors
//-------------------------------------------------------------------------------------------

- (void)didChangeItemsSet
{
    [self.tableViewManager sectionDidChangeItemsSet:self];
}

- (void)gotNewItems:(NSArray *)newItems
{
    for (CCTableViewItem *item in newItems) {
        if ([item isKindOfClass:[CCTableViewItem class]]) {
            item.section = self;
        }
    }

    [self.tableViewManager section:self gotNewItems:newItems];
}

@end
