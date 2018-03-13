//
// CCTableViewItem.h
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

#import <Foundation/Foundation.h>
#import "CCTableViewCellStyle.h"

@class CCTableViewSection;
@class CCTableViewCellFactory;

NS_ASSUME_NONNULL_BEGIN

@interface CCTableViewItem : NSObject

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *detailLabelText;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *highlightedImage;

@property (nonatomic, weak, nullable) CCTableViewSection *section;

@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, strong, nullable) UIView *accessoryView;
@property (nonatomic) BOOL enabled;
@property (nonatomic, copy, nullable) void (^selectionHandler)(id item);
@property (nonatomic, copy, nullable) void (^accessoryButtonTapHandler)(id item);
@property (nonatomic, copy, nullable) void (^insertionHandler)(id item);
@property (nonatomic, copy, nullable) void (^deletionHandler)(id item);
@property (nonatomic, copy, nullable) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (nonatomic, copy, nullable) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy, nullable) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy, nullable) void (^cutHandler)(id item);
@property (nonatomic, copy, nullable) void (^copyHandler)(id item);
@property (nonatomic, copy, nullable) void (^pasteHandler)(id item);

+ (instancetype)item;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^__nullable)(CCTableViewItem *item))selectionHandler;
+ (instancetype)itemWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^__nullable)(CCTableViewItem *item))selectionHandler accessoryButtonTapHandler:(void(^__nullable)(CCTableViewItem *item))accessoryButtonTapHandler;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^__nullable)(CCTableViewItem *item))selectionHandler;
- (id)initWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^__nullable)(CCTableViewItem *item))selectionHandler accessoryButtonTapHandler:(void(^__nullable)(CCTableViewItem *item))accessoryButtonTapHandler;

- (NSIndexPath *)indexPath;

///
/// Specifying cell for current item
///

- (CCTableViewCellFactory *)cellFactoryForCurrentItem;

- (NSString * __nullable)cellReusableIdentifier;

///-----------------------------
/// @name Manipulating table view row
///-----------------------------

- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRow;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRow;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END

