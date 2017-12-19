//
// CCTableViewManager.m
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

#import "CCTableViewManager.h"
#import "CCTableViewItem.h"
#import "CCTableViewCellFactory.h"
#import "CCMacroses.h"
#import "UIView+Positioning.h"


static CGFloat const kDefaultCellHeight = 60;


@interface CCTableViewCell()
- (void)sizeToFitWidth:(CGFloat)width;
+ (CGFloat)height;
@end


@interface CCTableViewManager ()

/**
 The array of pairs of items / cell classes.
 */
@property (nonatomic) NSMutableDictionary *registeredXIBs;
@property (nonatomic) NSMutableArray<CCTableViewSection *> *mutableSections;
@property (nonatomic) CGFloat defaultTableViewSectionHeight;
@property (nonatomic) CCTableViewSection *defaultSection;
@end


@implementation CCTableViewManager


- (void)dealloc
{
    self.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithTableView: instead." userInfo:nil];
    return nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<CCTableViewManagerDelegate>)delegate
{
    self = [self initWithTableView:tableView];
    if (!self) {
        return nil;
    }

    self.delegate = delegate;

    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (!self) {
        return nil;
    }

    tableView.delegate = self;
    tableView.dataSource = self;

    self.tableView = tableView;

    self.mutableSections = [NSMutableArray new];
    self.registeredClasses = [NSMutableDictionary new];
    self.registeredXIBs = [NSMutableDictionary new];
    self.style = [CCTableViewCellStyle new];

    return self;
}

+ (instancetype)withTableView:(UITableView *)tableView delegate:(id<CCTableViewManagerDelegate>)delegate
{
    return [[self alloc] initWithTableView:tableView delegate:delegate];
}

+ (instancetype)withTableView:(UITableView *)tableView
{
    return [[self alloc] initWithTableView:tableView];
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerClass:objectClass forCellWithReuseIdentifier:identifier bundle:nil];
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id<NSCopying>) NSClassFromString(objectClass)] = NSClassFromString(identifier);

    // Perform check if a XIB exists with the same name as the cell class
    //
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }

    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        self.registeredXIBs[identifier] = objectClass;
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:objectClass];
    }
}

- (id)objectAtKeyedSubscript:(id<NSCopying>)key
{
    return self.registeredClasses[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    [self registerClass:(NSString *) key forCellWithReuseIdentifier:obj];
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    NSObject *item = section.items[indexPath.row];
    Class clazz = self.registeredClasses[item.class];
    if (!clazz && [item isKindOfClass:[CCTableViewItem class]]) {
        CCTableViewCellFactory *cellConfig = [(CCTableViewItem *) item cellFactoryForCurrentItem];
        clazz = [cellConfig cellClass];
    }
    return clazz;
}

- (NSArray<CCTableViewSection *> *)sections
{
    return self.mutableSections;
}

- (CCTableViewSection *)defaultSection
{
    if (!_defaultSection) {
        if ([self.sections count] != 0) {
            return nil;
        }
        _defaultSection = [CCTableViewSection new];
        [self addSection:_defaultSection];
    }

    return _defaultSection;
}

- (CGFloat)defaultTableViewSectionHeight
{
    return self.tableView.style == UITableViewStyleGrouped ? 44 : 22;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (BOOL)respondsToSelector:(SEL)selector
{
    if (selector == @selector(tableView:estimatedHeightForRowAtIndexPath:)) {
        return !_estimatedHeightSupportDisabled;
    }
    return [super respondsToSelector:selector];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return 0;
    }
    return ((CCTableViewSection *) self.mutableSections[sectionIndex]).items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    CCTableViewItem *item = section.items[indexPath.row];

    CCTableViewCell *cell = nil;

    if ([item isKindOfClass:[CCTableViewItem class]]) {

        CCTableViewCellFactory *factory = [item cellFactoryForCurrentItem];

        cell = [factory cellForIndexPath:indexPath usingTableView:tableView item:item];
    } else {
        // Remove this way of using CCTableViewManager.
        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;

        NSString *cellIdentifier = [NSString stringWithFormat:@"CCTableViewManager_%@_%li", [item class], (long) cellStyle];

        Class cellClass = [self classForCellAtIndexPath:indexPath];

        if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
            cellIdentifier = self.registeredXIBs[NSStringFromClass(cellClass)];
        }

        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }

    [self loadCellIfNeeded:cell table:tableView indexPath:indexPath];

    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.section = section;
    cell.item = item;
    cell.detailTextLabel.text = nil;

    if ([item isKindOfClass:[CCTableViewItem class]]) {
        cell.detailTextLabel.text = ((CCTableViewItem *) item).detailLabelText;
    }

    [cell cellWillAppear];

    if ([cell isKindOfClass:[CCTableViewCell class]]) {
        [self willAppearCell:cell];
    }

    return cell;
}

- (void)loadCellIfNeeded:(CCTableViewCell *)cell table:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CCTableViewCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        cell.tableViewManager = self;

        if ([self.delegate conformsToProtocol:@protocol(CCTableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)]) {
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        }

        [cell cellDidLoad];

        [self didLoadCell:cell];

        // CCTableViewManagerDelegate
        //
        if ([self.delegate conformsToProtocol:@protocol(CCTableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)]) {
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
        }

    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles;
    for (CCTableViewSection *section in self.mutableSections) {
        if (section.indexTitle) {
            titles = [NSMutableArray array];
            break;
        }
    }
    if (titles) {
        for (CCTableViewSection *section in self.mutableSections) {
            [titles addObject:section.indexTitle ? section.indexTitle : @""];
        }
    }

    return titles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];
    return section.footerTitle;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    CCTableViewSection *sourceSection = self.mutableSections[sourceIndexPath.section];
    CCTableViewItem *item = sourceSection.items[sourceIndexPath.row];
    [sourceSection removeItemAtIndex:sourceIndexPath.row];

    CCTableViewSection *destinationSection = self.mutableSections[destinationIndexPath.section];
    [destinationSection insertItem:item atIndex:destinationIndexPath.row];

    if (item.moveCompletionHandler) {
        item.moveCompletionHandler(item, sourceIndexPath, destinationIndexPath);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section) {
        return NO;
    }
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    CCTableViewItem *item = section.items[indexPath.row];
    return item.moveHandler != nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.mutableSections count]) {
        CCTableViewSection *section = self.mutableSections[indexPath.section];
        if (indexPath.row < [section.items count]) {
            CCTableViewItem *item = section.items[indexPath.row];
            if ([item isKindOfClass:[CCTableViewItem class]]) {
                return item.editingStyle != UITableViewCellEditingStyleNone || item.moveHandler;
            }
        }
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CCTableViewSection *section = self.mutableSections[indexPath.section];
        CCTableViewItem *item = section.items[indexPath.row];
        if (item.deletionHandlerWithCompletion) {
            item.deletionHandlerWithCompletion(item, ^{
                [self deleteRowAtIndexPath:indexPath];
            });
        } else {
            if (item.deletionHandler) {
                item.deletionHandler(item);
            }
            [self deleteRowAtIndexPath:indexPath];
        }
    }

    if (editingStyle == UITableViewCellEditingStyleInsert) {
        CCTableViewSection *section = self.mutableSections[indexPath.section];
        CCTableViewItem *item = section.items[indexPath.row];
        if (item.insertionHandler) {
            item.insertionHandler(item);
        }
    }
}

#pragma mark -
#pragma mark Table view delegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CCTableViewCell class]]) {
        [(CCTableViewCell *) cell cellDidDisappear];
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    Class cellClass = [[item cellFactoryForCurrentItem] cellClass];

    if ([cellClass respondsToSelector:@selector(height)]) {
        let height = [cellClass height];
        if (height != 0) {
            return height;
        }
    }

    if ([cellClass methodForSelector:@selector(heightWithItem:tableViewManager:)] != [CCTableViewCell methodForSelector:@selector(heightWithItem:tableViewManager:)]) {
        return [cellClass heightWithItem:item tableViewManager:self];
    }

    NSString *cellIdentifier = [[self class] reuseIdentifierForCellHeightClass:cellClass];

    CCTableViewCell *cell = self.heightCellCache[cellIdentifier];
    if (!cell) {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
        cell = [(CCTableViewCell *)[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        self.heightCellCache[cellIdentifier] = cell;
    }

    if (![cell isKindOfClass:[CCTableViewCell class]]) {
        return kDefaultCellHeight;
    }

    if (!cell.loaded) {
        [cell cellDidLoad];
    }

    cell.item = item;

    if ([cell respondsToSelector:@selector(sizeToFitWidth:)]) {
        [cell sizeToFitWidth:self.tableView.width];
        let height = cell.height;
        if (height != 0) {
            return height;
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }

    return [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];

    if (section.headerHeight != CCTableViewSectionHeaderHeightAutomatic) {
        return section.headerHeight;
    }

    if (section.headerView) {
        return section.headerView.frame.size.height;
    } else if (section.headerTitle.length) {
        if (tableView.style != UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side

            CGSize headerRect = CGSizeMake(headerWidth, CCTableViewSectionHeaderHeightAutomatic);

            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                                   context:nil];

            headerHeight = headerFrame.size.height;

            return headerHeight + 20.0f;
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];

    if (section.footerHeight != CCTableViewSectionFooterHeightAutomatic) {
        return section.footerHeight;
    }

    if (section.footerView) {
        return section.footerView.frame.size.height;
    } else if (section.footerTitle.length) {
        if (tableView.style != UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side

            CGSize footerRect = CGSizeMake(footerWidth, CCTableViewSectionFooterHeightAutomatic);

            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]}
                                                                   context:nil];

            footerHeight = footerFrame.size.height;

            return footerHeight + 10.0f;
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    }

    return 0;
}

// Estimated height support
// NOTE: this method may not be called if estimatedHeightSupportDisabled set to YES.

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    CCTableViewSection *section = self.mutableSections[indexPath.section];

    id item = section.items[indexPath.row];

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }

    CGFloat height = [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];

    if (CCIOSVersionLessThan(11.0) && (ceil(height) == 1)) {
        height = 1.01;
    }

    return height ? height : UITableViewAutomaticDimension;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }

    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    CCTableViewSection *section = self.mutableSections[sectionIndex];

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }

    return section.footerView;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    if ([item respondsToSelector:@selector(setAccessoryButtonTapHandler:)]) {
        CCTableViewItem *actionItem = (CCTableViewItem *) item;
        if (actionItem.accessoryButtonTapHandler) {
            actionItem.accessoryButtonTapHandler(item);
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }

    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }

    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        CCTableViewItem *actionItem = (CCTableViewItem *) item;
        if (actionItem.selectionHandler) {
            actionItem.selectionHandler(item);
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    CCTableViewItem *item = section.items[indexPath.row];

    if (![item isKindOfClass:[CCTableViewItem class]]) {
        return UITableViewCellEditingStyleNone;
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }

    return item.editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }

    return NSLocalizedString(@"Delete", @"Delete");
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                           editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }

    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    CCTableViewSection *sourceSection = self.mutableSections[sourceIndexPath.section];
    CCTableViewItem *item = sourceSection.items[sourceIndexPath.row];
    if (item.moveHandler) {
        BOOL allowed = item.moveHandler(item, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed) {
            return sourceIndexPath;
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }

    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }

    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    id anItem = section.items[indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        CCTableViewItem *item = anItem;
        if (item.copyHandler || item.pasteHandler) {
            return YES;
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }

    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self.mutableSections count] <= indexPath.section) {
        return NO;
    }
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    if ([section.items count] <= indexPath.row) {
        return NO;
    }

    id anItem = section.items[indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        CCTableViewItem *item = anItem;
        if (item.copyHandler && action == @selector(copy:)) {
            return YES;
        }

        if (item.pasteHandler && action == @selector(paste:)) {
            return YES;
        }

        if (item.cutHandler && action == @selector(cut:)) {
            return YES;
        }
    }

    // Forward to UITableViewDelegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    CCTableViewSection *section = self.mutableSections[indexPath.section];
    CCTableViewItem *item = section.items[indexPath.row];

    if (action == @selector(copy:)) {
        if (item.copyHandler) {
            item.copyHandler(item);
        }
    }

    if (action == @selector(paste:)) {
        if (item.pasteHandler) {
            item.pasteHandler(item);
        }
    }

    if (action == @selector(cut:)) {
        if (item.cutHandler) {
            item.cutHandler(item);
        }
    }

    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:self.tableView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:self.tableView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:self.tableView];
    }

    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:self.tableView];
    }
}

#pragma mark -
#pragma mark Managing sections

- (void)addSection:(CCTableViewSection *)section
{
    [self removeDefaultSectionIfNeeded];

    [self gotNewSections:@[section]];
    [self.mutableSections addObject:section];
    [self sectionsSetChanged];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    if ([self.mutableSections count] == 1 && ([self.mutableSections firstObject] == _defaultSection)) {
        _defaultSection = nil;
        [self.mutableSections removeAllObjects];
    }

    [self gotNewSections:array];
    [self.mutableSections addObjectsFromArray:array];
    [self sectionsSetChanged];
}

- (void)insertSection:(CCTableViewSection *)section atIndex:(NSUInteger)index
{
    [self gotNewSections:@[section]];
    [self.mutableSections insertObject:section atIndex:index];
    [self sectionsSetChanged];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    [self gotNewSections:sections];
    [self.mutableSections insertObjects:sections atIndexes:indexes];
    [self sectionsSetChanged];
}

- (void)removeSection:(CCTableViewSection *)section
{
    [self.mutableSections removeObject:section];
    [self sectionsSetChanged];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
    [self sectionsSetChanged];
}

- (void)removeSectionIdenticalTo:(CCTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
    [self sectionsSetChanged];
}

- (void)removeSectionIdenticalTo:(CCTableViewSection *)section
{
    [self.mutableSections removeObjectIdenticalTo:section];
    [self sectionsSetChanged];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
    [self sectionsSetChanged];
}

- (void)removeSectionsInRange:(NSRange)range
{
    [self.mutableSections removeObjectsInRange:range];
    [self sectionsSetChanged];
}

- (void)removeSection:(CCTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObject:section inRange:range];
    [self sectionsSetChanged];
}

- (void)removeLastSection
{
    [self.mutableSections removeLastObject];
    [self sectionsSetChanged];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
    [self sectionsSetChanged];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableSections removeObjectsAtIndexes:indexes];
    [self sectionsSetChanged];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(CCTableViewSection *)section
{
    [self gotNewSections:@[section]];

    [self.mutableSections replaceObjectAtIndex:index withObject:section];

    [self sectionsSetChanged];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray
{
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections
{
    [self gotNewSections:sections];

    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];

    [self sectionsSetChanged];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    [self gotNewSections:otherArray];

    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];

    [self sectionsSetChanged];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray
{
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2
{
    [self.mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator
{
    [self.mutableSections sortUsingSelector:comparator];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Modifying callbacks
//-------------------------------------------------------------------------------------------

- (void)sectionsSetChanged
{
    [self didChangeItemsSet];
}

- (void)gotNewSections:(NSArray *)sections
{
    for (CCTableViewSection *section in sections) {
        section.tableViewManager = self;
        [self gotNewItems:section.items];
    }
}

- (void)sectionDidChangeItemsSet:(CCTableViewSection *)section
{
    [self didChangeItemsSet];
}

- (void)section:(CCTableViewSection *)section gotNewItems:(NSArray *)items
{
    [self gotNewItems:items];

}

- (void)gotNewItems:(NSArray *)items
{

}

- (void)didChangeItemsSet
{

}

- (void)willAppearCell:(CCTableViewCell *)cell
{

}

- (void)didLoadCell:(CCTableViewCell *)cell
{

}

//-------------------------------------------------------------------------------------------
#pragma mark - Items Managment
//-------------------------------------------------------------------------------------------

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.sections count] > indexPath.section && indexPath.section >= 0) {
        CCTableViewSection *section = self.sections[(NSUInteger) indexPath.section];
        if ([section.items count] > indexPath.row && indexPath.row >= 0) {
            return section.items[(NSUInteger) indexPath.row];
        }
    }
    return nil;
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.sections count] > indexPath.section) {

        CCTableViewSection *section = self.sections[(NSUInteger) indexPath.section];

        [section removeItemAtIndex:(NSUInteger) indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self updateVisibleCellRowIndexes];
    }
}

- (void)updateVisibleCellRowIndexes
{
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if ([cell isKindOfClass:[CCTableViewCell class]]) {
            CCTableViewCell *customCell = (id) cell;
            CCTableViewItem *item = customCell.item;
            customCell.rowIndex = item.indexPath.row;
        }
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)removeDefaultSectionIfNeeded
{
    if ([self.mutableSections count] == 1 && ([self.mutableSections firstObject] == _defaultSection)) {
        _defaultSection = nil;
        [self.mutableSections removeAllObjects];
    }
}

- (void)cleanUpHeightCache
{
    [[self heightCellCache] removeAllObjects];
}

+ (NSString *)reuseIdentifierForCellHeightClass:(Class)cls
{
    return [NSString stringWithFormat:@"%@_Height", NSStringFromClass(cls)];
}

- (NSMutableDictionary *)heightCellCache
{
    id cellCache = GetAssociatedObject(@selector(heightCellCache));
    if (!cellCache) {
        cellCache = [NSMutableDictionary new];
        SetAssociatedObject(@selector(heightCellCache), cellCache);
    }
    return cellCache;
}

@end
