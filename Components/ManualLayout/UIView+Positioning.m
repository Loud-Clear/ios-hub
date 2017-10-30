////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <UIkit/UIkit.h>
#import "UIView+Positioning.h"
#import "CCUIRound.h"

const OSInsets OSInsetsZero = {{0}, {0}};

@interface UIView (SizeToFitWidth)
- (void)sizeToFitWidth:(CGFloat)width;
@end


@implementation UIView (Positioning)

//-------------------------------------------------------------------------------------------
#pragma mark - Properties
//-------------------------------------------------------------------------------------------

- (void)setX:(CGFloat)x
{
    x = CCUIRound(x);
    self.center = CGPointMake(x + self.boundsWidth/2, self.center.y);
}

- (void)setLeft:(CGFloat)left
{
    self.x = left;
}

- (void)setY:(CGFloat)y
{
    y = CCUIRound(y);
    self.center = CGPointMake(self.center.x, y + self.boundsHeight/2);
}

- (void)setTop:(CGFloat)top
{
    self.y = top;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (void)setOrigin:(CGPoint)origin
{
    self.x = origin.x;
    self.y = origin.y;
}

- (void)setSize:(CGSize)size
{
    self.width = size.width;
    self.height = size.height;
}

- (void)setRight:(CGFloat)right
{
    self.x = right - self.width;
}

- (void)setBottom:(CGFloat)bottom
{
    self.y = bottom - self.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    centerX = CCUIRound(centerX - self.boundsWidth / 2) + self.boundsWidth/2;
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY
{
    centerY = CCUIRound(centerY - self.boundsHeight / 2) + self.boundsHeight/2;
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setBoundsX:(CGFloat)boundsX
{
    self.bounds = CGRectMake(boundsX, self.boundsY, self.boundsWidth, self.boundsHeight);
}

- (void)setBoundsY:(CGFloat)boundsY
{
    self.bounds = CGRectMake(self.boundsX, boundsY, self.boundsWidth, self.boundsHeight);
}

- (void)setBoundsWidth:(CGFloat)boundsWidth
{
    self.bounds = CGRectMake(self.boundsX, self.boundsY, boundsWidth, self.boundsHeight);
}

- (void)setBoundsHeight:(CGFloat)boundsHeight
{
    self.bounds = CGRectMake(self.boundsX, self.boundsY, self.boundsWidth, boundsHeight);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)left
{
    return self.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)top
{
    return self.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGPoint)origin
{
    return CGPointMake(self.x, self.y);
}

- (CGSize)size
{
    return CGSizeMake(self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)boundsX
{
    return self.bounds.origin.x;
}

- (CGFloat)boundsY
{
    return self.bounds.origin.y;
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)boundsSize
{
    CGRect bounds = self.bounds;
    bounds.size = boundsSize;
    self.bounds = bounds;
}

- (CGPoint)boundsCenter
{
    return CGPointMake((self.bounds.origin.x + self.bounds.size.width)/2, (self.bounds.origin.y + self.bounds.size.height)/2);
}

- (CGPoint)frameCenter
{
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)centerToParent
{
    [self centerInSuperview];
}

- (CGPoint)topLeft
{
    return CGPointMake(self.x, self.y);
}

- (void)setTopLeft:(CGPoint)topLeft
{
    self.x = topLeft.x;
    self.y = topLeft.y;
}

- (CGPoint)topRight
{
    return CGPointMake(self.right, self.y);
}

- (void)setTopRight:(CGPoint)topRight
{
    self.right = topRight.x;
    self.y = topRight.y;
}

- (CGPoint)bottomLeft
{
    return CGPointMake(self.x, self.bottom);
}

- (void)setBottomLeft:(CGPoint)bottomLeft
{
    self.x = bottomLeft.x;
    self.bottom = bottomLeft.y;
}

- (CGPoint)bottomRight
{
    return CGPointMake(self.right, self.bottom);
}

- (void)setBottomRight:(CGPoint)bottomRight
{
    self.right = bottomRight.x;
    self.bottom = bottomRight.y;
}

- (void)setAttr:(OSAttr)attr value:(CGFloat)value
{
    if (attr == OSAttrLeft) {
        self.x = value;
    } else if (attr == OSAttrRight) {
        self.right = value;
    } else if (attr == OSAttrTop) {
        self.y = value;
    } else if (attr == OSAttrBottom) {
        self.bottom = value;
    } else if (attr == OSAttrCenterX) {
        self.centerX = value;
    } else if (attr == OSAxisCenterY) {
        self.centerY = value;
    } else {
        NSAssert(NO, nil);
    }
}

- (CGFloat)getAttrValue:(OSAttr)attr
{
    if (attr == OSAttrLeft) {
        return self.x;
    } else if (attr == OSAttrRight) {
        return self.right;
    } else if (attr == OSAttrTop) {
        return self.y;
    } else if (attr == OSAttrBottom) {
        return self.bottom;
    } else if (attr == OSAttrCenterX) {
        return self.centerX;
    } else if (attr == OSAxisCenterY) {
        return self.centerY;
    } else {
        NSAssert(NO, nil);
        return 0;
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Moving
//-------------------------------------------------------------------------------------------

- (void)moveX:(CGFloat)x
{
    self.width = self.width + (self.x - x);
    self.x = x;
}

- (void)moveY:(CGFloat)y;
{
    self.height = self.height + (self.y - y);
    self.y = y;
}

- (void)moveRight:(CGFloat)right
{
    self.width = self.width + (right - self.right);
}

- (void)moveBottom:(CGFloat)bottom
{
    self.height = self.height + (bottom - self.bottom);
}

- (void)moveRightToSuperviewWithOffset:(CGFloat)offset
{
    [self moveRight:self.superview.boundsWidth - offset];
}

- (void)moveRightToSuperview
{
    [self moveRightToSuperviewWithOffset:0];
}

- (void)moveRightToView:(UIView *)view withOffset:(CGFloat)offset
{
    [self moveRight:view.x - offset];
}

- (void)moveRightToView:(UIView *)view
{
    [self moveRightToView:view withOffset:0];
}

- (void)moveBottomToSuperviewWithOffset:(CGFloat)offset
{
    [self moveBottom:self.superview.boundsHeight - offset];
}

- (void)moveBottomToSuperview
{
    [self moveBottomToSuperviewWithOffset:0];
}

- (void)moveAttr:(OSAttr)attr value:(CGFloat)value
{
    if (attr == OSAttrLeft) {
        [self moveX:value];
    } else if (attr == OSAttrRight) {
        [self moveRight:value];
    } else if (attr == OSAttrTop) {
        [self moveY:value];
    } else if (attr == OSAttrBottom) {
        [self moveBottom:value];
    } else {
        NSAssert(NO, nil);
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Fitting
//-------------------------------------------------------------------------------------------

- (void)fitToSuperview
{
    self.frame = self.superview.bounds;
}

- (void)fitHorizontallyToSuperview
{
    self.x = 0;
    self.width = self.superview.boundsWidth;
}

- (void)fitVerticallyToSuperview
{
    self.y = 0;
    self.height = self.superview.boundsHeight;
}

- (void)fitToSuperviewWithInsets:(UIEdgeInsets)insets
{
    [self fitHorizontallyToSuperviewWithInsets:OSInsetsMake(insets.left, insets.right)];
    [self fitVerticallyToSuperviewWithInsets:OSInsetsMake(insets.top, insets.bottom)];
}

- (void)fitHorizontallyToSuperviewWithInsets:(OSInsets)insets
{
    self.x = insets.left;
    self.width = self.superview.boundsWidth - insets.left - insets.right;
}

- (void)fitVerticallyToSuperviewWithInsets:(OSInsets)insets
{
    self.y = insets.top;
    self.height = self.superview.boundsHeight - insets.top - insets.bottom;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Ensuring fitting
//-------------------------------------------------------------------------------------------

- (void)ensureFitsVerticallyToSuperview
{
    if (self.superview && self.height > self.superview.boundsHeight) {
        self.height = self.superview.boundsHeight;
    }
}

- (void)ensureFitsHorizontallyToSuperview
{
    if (self.superview && self.width > self.superview.boundsWidth) {
        self.width = self.superview.boundsWidth;
    }
}

- (void)ensureFitsSubviewsMaxWidth
{
    CGFloat maxSubviewWidth = [self subviewsMaxWidth];

    if (self.width < maxSubviewWidth) {
        self.width = maxSubviewWidth;
    }
}

- (void)ensureFitsSubviewsMaxHeight
{
    CGFloat maxSubviewHeight = [self subviewsMaxHeight];

    if (self.height < maxSubviewHeight) {
        self.height = maxSubviewHeight;
    }
}

- (void)ensureFitsToSuperview
{
    [self ensureFitsHorizontallyToSuperview];
    [self ensureFitsVerticallyToSuperview];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Centering
//-------------------------------------------------------------------------------------------

- (void)centerHorizontallyInSuperview
{
    self.centerX = self.superview.boundsWidth/2;
}

- (void)centerVerticallyInSuperview
{
    self.centerY = self.superview.boundsHeight/2;
}

- (void)centerInSuperview
{
    [self centerHorizontallyInSuperview];
    [self centerVerticallyInSuperview];
}

- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view
{
    [self centerHorizontallyBetweenSuperviewAndView:view withOffset:0];
}

- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view withOffset:(CGFloat)offset
{
    self.centerX = view.x/2 + offset;
}

- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view
{
    [self centerHorizontallyBetweenViewAndSuperview:view withOffset:0];
}

- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view withOffset:(CGFloat)offset
{
    self.centerX = view.right + (self.width - view.right)/2 + offset;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Pinning
//-------------------------------------------------------------------------------------------

- (void)pinTopToSuperview
{
    self.y = 0;
}

- (void)pinBottomToSuperview
{
    self.bottom = self.superview.boundsHeight;
}

- (void)pinLeftToSuperview
{
    self.x = 0;
}

- (void)pinLeftToView:(UIView *)view
{
    [self pinLeftToView:view withOffset:0];
}

- (void)pinLeftToView:(UIView *)view withOffset:(CGFloat)offset
{
    self.x = view.right + offset;
}

- (void)pinRightToSuperview
{
    self.right = self.superview.boundsWidth;
}

- (void)pinTopLeftToSuperview
{
    self.x = 0;
    self.y = 0;
}

- (void)pinTopRightToSuperview
{
    self.right = self.superview.boundsWidth;
    self.y = 0;
}

- (void)pinBottomLeftToSuperview
{
    self.x = 0;
    self.bottom = self.superview.boundsHeight;
}

- (void)pinBottomRightToSuperview
{
    self.right = self.superview.boundsWidth;
    self.bottom = self.superview.boundsHeight;
}

- (void)pinTopLeftToSuperviewWithOffset:(UIOffset)offset
{
    self.x = offset.horizontal;
    self.y = offset.vertical;
}

- (void)pinTopRightToSuperviewWithOffset:(UIOffset)offset
{
    self.right = self.superview.boundsWidth - offset.horizontal;
    self.y = offset.vertical;
}

- (void)pinBottomLeftToSuperviewWithOffset:(UIOffset)offset
{
    self.x = offset.horizontal;
    self.bottom = self.superview.boundsHeight - offset.vertical;
}

- (void)pinBottomRightToSuperviewWithOffset:(UIOffset)offset
{
    self.right = self.superview.boundsWidth - offset.horizontal;
    self.bottom = self.superview.boundsHeight - offset.vertical;
}

- (void)pinTopToSuperviewWithOffset:(CGFloat)offset
{
    self.y = offset;
}

- (void)pinBottomToSuperviewWithOffset:(CGFloat)offset
{
    self.bottom = self.superview.boundsHeight - offset;
}

- (void)pinLeftToSuperviewWithOffset:(CGFloat)offset
{
    self.x = offset;
}

- (void)pinRightToSuperviewWithOffset:(CGFloat)offset
{
    self.right = self.superview.boundsWidth - offset;
}

- (void)pinRightToView:(UIView *)view
{
    [self pinRightToView:view withOffset:0];
}

- (void)pinRightToView:(UIView *)view withOffset:(CGFloat)offset
{
    self.right = view.x - offset;
}

- (void)pinTopToControllerTopLayoutGuide:(UIViewController *)controller
{
    [self pinTopToControllerLayoutGuide:controller withOffset:0];
}

- (void)pinTopToControllerLayoutGuide:(UIViewController *)controller withOffset:(CGFloat)offset
{
    self.y = controller.topLayoutGuide.length + offset;
}

- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge
{
    [self pinEdge:edge toView:view edge:edge withOffset:0];
}

- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge withOffset:(CGFloat)offset
{
    [self pinAttr:(OSAttr)edge toView:view attr:(OSAttr)viewEdge withOffset:offset];
}

- (void)pinAttr:(OSAttr)attr toView:(UIView *)view attr:(OSAttr)viewAttr
{
    [self pinAttr:attr toView:view attr:viewAttr withOffset:0];
}

- (void)pinAttr:(OSAttr)attr toView:(UIView *)view attr:(OSAttr)viewAttr withOffset:(CGFloat)offset
{
    [self setAttr:attr value:[view getAttrValue:viewAttr] + offset];
}

- (void)pinAttr:(OSAttr)attr toView:(UIView *)view
{
    [self pinAttr:attr toView:view withOffset:0];
}

- (void)pinAttr:(OSAttr)attr toView:(UIView *)view withOffset:(CGFloat)offset
{
    [self pinAttr:attr toView:view attr:attr withOffset:offset];
}

- (void)pinBottomToViewTop:(UIView *)view withOffset:(CGFloat)offset
{
    [self pinEdge:OSEdgeBottom toView:view edge:OSEdgeTop withOffset:-offset];
}

- (void)pinBottomToViewTop:(UIView *)view
{
    [self pinBottomToViewTop:view withOffset:0];
}

- (void)pinTopToViewBottom:(UIView *)view
{
    [self pinTopToViewBottom:view withOffset:0];
}

- (void)pinTopToViewBottom:(UIView *)view withOffset:(CGFloat)offset
{
    [self pinEdge:OSEdgeTop toView:view edge:OSEdgeBottom withOffset:offset];
}

- (void)fitHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2
{
    [self fitHorizontallyBetweenView:view1 andView:view2 withInsets:OSInsetsZero];
}

- (void)fitVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2
{
    [self fitVerticallyBetweenView:view1 andView:view2 withInsets:OSInsetsZero];
}

- (void)fitHorizontallyBetweenViewAndSuperview:(UIView *)view
{
    [self fitHorizontallyBetweenViewAndSuperview:view withInsets:OSInsetsZero];
}

- (void)fitHorizontallyBetweenSuperviewAndView:(UIView *)view
{
    [self fitHorizontallyBetweenSuperviewAndView:view withInsets:OSInsetsZero];
}

- (void)fitVerticallyBetweenSuperviewAndView:(UIView *)view
{
    [self fitVerticallyBetweenSuperviewAndView:view withInsets:OSInsetsZero];
}

- (void)fitVerticallyBetweenViewAndSuperview:(UIView *)view
{
    [self fitVerticallyBetweenViewAndSuperview:view withInsets:OSInsetsZero];
}

- (void)fitHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withInsets:(OSInsets)insets
{
    self.width = view2.x - view1.right - insets.left - insets.right;
    self.x = view1.right + insets.left;
}

- (void)fitVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withInsets:(OSInsets)insets
{
    self.height = view2.y - view1.bottom - insets.top - insets.bottom;
    self.y = view1.bottom + insets.top;
}

- (void)fitHorizontallyBetweenViewAndSuperview:(UIView *)view withInsets:(OSInsets)insets
{
    self.x = view.right + insets.left;
    self.width = self.superview.boundsWidth - view.right - insets.left - insets.right;
}

- (void)fitHorizontallyBetweenSuperviewAndView:(UIView *)view withInsets:(OSInsets)insets
{
    self.x = 0 + insets.left;
    self.width = view.x - insets.left - insets.right;
}

- (void)fitVerticallyBetweenSuperviewAndView:(UIView *)view withInsets:(OSInsets)insets
{
    self.y = 0 + insets.top;
    self.height = view.y - insets.top - insets.bottom;
}

- (void)fitVerticallyBetweenViewAndSuperview:(UIView *)view withInsets:(OSInsets)insets
{
    self.y = view.bottom + insets.top;
    self.height = self.superview.boundsHeight - view.bottom - insets.top - insets.bottom;
}

- (void)ensureWidthIsNoMoreThan:(CGFloat)maxWidth
{
    if (maxWidth < 0) {
        maxWidth = 0;
    }

    if (self.width > maxWidth) {
        self.width = maxWidth;
    }
}

- (void)ensureHeightIsNoMoreThan:(CGFloat)maxHeight
{
    if (maxHeight < 0) {
        maxHeight = 0;
    }

    if (self.height > maxHeight) {
        self.height = maxHeight;
    }
}

- (void)ensureRightIsNotCloserThan:(CGFloat)offset toView:(UIView *)view
{
    if (view.x - self.right < offset) {
        self.right = view.x - offset;
    }
}

- (void)ensureLeftIsNotCloserThan:(CGFloat)offset toView:(UIView *)view
{
    if (self.x - view.right < offset) {
        self.x = view.right + offset;
    }
}

- (void)fixOrigin
{
    // Calculate origin. Not using self.frame.origin because it may be invalid if view is transformed (center & bounds are always valid).
    CGPoint origin = CGPointMake(self.center.x - self.bounds.size.width/2, self.center.y - self.bounds.size.height/2);

    // Convert to window coordinates
    origin = [self.superview convertPoint:origin toView:[UIApplication sharedApplication].keyWindow];

    // Align to physical pixels
    origin = CGPointMake(CCUIRound(origin.x), CCUIRound(origin.y));

    // Convert back to superview coordinates
    origin = [self.superview convertPoint:origin fromView:[UIApplication sharedApplication].keyWindow];

    // Adjust origin by changing center.
    CGPoint newCenter = CGPointMake(origin.x + self.bounds.size.width/2, origin.y + self.bounds.size.height/2);
    self.center = newCenter;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Subviews
//-------------------------------------------------------------------------------------------

- (CGRect)subviewsBoundingBox:(NSArray<UIView *> *)views
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat right = 0;
    CGFloat bottom = 0;

    for (UIView *view in views) {
        x = fmin(view.x, x);
        y = fmin(view.y, y);
        right = fmax(view.right, right);
        bottom = fmax(view.bottom, bottom);
    }

    CGRect rect = CGRectMake(x, y, right - x, bottom - y);
    return rect;
}

- (CGRect)subviewsBoundingBox
{
    return [self subviewsBoundingBox:self.subviews];
}

- (void)subviewsStackAndCenterHorizontally:(NSArray<UIView *> *)views
{
    [self subviewsStackAndCenterHorizontally:views withMargin:0];
}

- (void)subviewsStackAndCenterHorizontally:(NSArray<UIView *> *)views withMargin:(CGFloat)margin
{
    CGFloat totalWidth = 0;
    for (UIView *view in views) {
        totalWidth += view.width;
        if ([views lastObject] != view) {
            totalWidth += margin;
        }
    }

    CGFloat x = (self.width - totalWidth)/2;

    for (UIView *view in views) {
        view.centerX = x + view.width/2;
        x += view.width;
        if ([views lastObject] != view) {
            x += margin;
        }
    }
}

- (void)subviewsStackAndCenterHorizontally
{
    [self subviewsStackAndCenterHorizontally:self.subviews];
}

- (void)subviewsStackAndCenterHorizontallyWithMargin:(CGFloat)margin
{
    [self subviewsStackAndCenterHorizontally:self.subviews withMargin:margin];
}

- (void)subviewsStackAndCenterVertically:(NSArray<UIView *> *)views
{
    [self subviewsStackAndCenterVertically:views withMargin:0];
}

- (void)subviewsStackAndCenterVertically:(NSArray<UIView *> *)views withMargin:(CGFloat)margin
{
    CGFloat totalHeight = 0;
    for (UIView *view in views) {
        totalHeight += view.height;
        if ([views lastObject] != view) {
            totalHeight += margin;
        }
    }

    CGFloat y = (self.height - totalHeight)/2;

    for (UIView *view in views) {
        view.centerY = y + view.height/2;
        y += view.height;
        if ([views lastObject] != view) {
            y += margin;
        }
    }
}

- (void)subviewsStackAndCenterVertically
{
    [self subviewsStackAndCenterVerticallyWithMargin:0];
}

- (void)subviewsStackAndCenterVerticallyWithMargin:(CGFloat)margin
{
    [self subviewsStackAndCenterVertically:self.subviews withMargin:margin];
}

- (void)subviewsCenterHorizontallyToSuperview
{
    for (UIView *view in self.subviews) {
        [view centerHorizontallyInSuperview];
    }
}

- (void)subviewsCenterVerticallyToSuperview
{
    for (UIView *view in self.subviews) {
        [view centerVerticallyInSuperview];
    }
}

- (CGFloat)subviewsMaxWidth:(NSArray<UIView *> *)views
{
    CGFloat maxWidth = 0;

    for (UIView *view in views) {
        if (view.width > maxWidth) {
            maxWidth = view.width;
        }
    }

    return maxWidth;
}

- (CGFloat)subviewsMaxHeight
{
    return [self subviewsMaxHeight:self.subviews];
}

- (CGFloat)subviewsMaxHeight:(NSArray<UIView *> *)views
{
    CGFloat maxHeight = 0;

    for (UIView *view in views) {
        if (view.height > maxHeight) {
            maxHeight = view.height;
        }
    }

    return maxHeight;
}

- (CGFloat)subviewsMaxWidth
{
    return [self subviewsMaxWidth:self.subviews];
}

- (void)subviewsSizeToFitAll
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view sizeToFit];
        }
    }
}

- (void)subviewsSizeToFitWidthAll:(CGFloat)width
{
    for (UIView *view in self.subviews) {
        if ([view respondsToSelector:@selector(sizeToFitWidth:)]) {
            [view sizeToFitWidth:width];
        }
    }
}

- (CGFloat)subviewsMinAttrValue:(OSAttr)attr
{
    return [self subviews:self.subviews minAttrValue:attr];
}

- (CGFloat)subviewsMaxAttrValue:(OSAttr)attr
{
    return [self subviews:self.subviews maxAttrValue:attr];
}

- (CGFloat)subviews:(NSArray<UIView *> *)views minAttrValue:(OSAttr)attr
{
    NSNumber *minValue = nil;

    for (UIView *view in views) {
        CGFloat value = [view getAttrValue:attr];
        if (!minValue || value < [minValue floatValue]) {
            minValue = @(value);
        }
    }

    return [minValue floatValue];}

- (CGFloat)subviews:(NSArray<UIView *> *)views maxAttrValue:(OSAttr)attr
{
    NSNumber *maxValue = nil;

    for (UIView *view in views) {
        CGFloat value = [view getAttrValue:attr];
        if (!maxValue || value > [maxValue floatValue]) {
            maxValue = @(value);
        }
    }

    return [maxValue floatValue];
}

@end
