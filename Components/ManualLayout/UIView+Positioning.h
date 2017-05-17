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

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef struct OSInsets
{
    union
    {
        CGFloat left;
        CGFloat top;
    };
    union
    {
        CGFloat right;
        CGFloat bottom;
    };
} OSInsets;

UIKIT_STATIC_INLINE OSInsets OSInsetsMake(CGFloat leftOrTop, CGFloat rightOrBottom)
{
    OSInsets insets = {{leftOrTop}, {rightOrBottom}};
    return insets;
}

extern const OSInsets OSInsetsZero;


typedef NS_ENUM(NSInteger, OSAttr)
{
    OSAttrLeft,
    OSAttrRight,
    OSAttrTop,
    OSAttrBottom,
    OSAttrCenterX,
    OSAttrCenterY,
};

typedef NS_ENUM(NSInteger, OSEdge)
{
    OSEdgeLeft = OSAttrLeft,
    OSEdgeRight = OSAttrRight,
    OSEdgeTop = OSAttrTop,
    OSEdgeBottom = OSAttrBottom,
};

typedef NS_ENUM(NSInteger, OSAxis)
{
    OSAxisCenterX = OSAttrCenterX,
    OSAxisCenterY = OSAttrCenterY,
};

@interface UIView (Positioning)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGPoint bottomRight;

/**
 * 'moveXXX' series of functions will change corresponding parameter by adjusting view dimensions instead of moving view (relative to opposite corner).
 * For example, moveX will change change value of both .x and .width so that .right will remain the same as before.
 */
- (void)moveX:(CGFloat)x;
- (void)moveY:(CGFloat)y;
- (void)moveRight:(CGFloat)right;
- (void)moveBottom:(CGFloat)bottom;

- (void)moveRightToSuperviewWithOffset:(CGFloat)offset;
- (void)moveRightToSuperview;

- (void)moveRightToView:(UIView *)view withOffset:(CGFloat)offset;
- (void)moveRightToView:(UIView *)view;

- (void)moveBottomToSuperviewWithOffset:(CGFloat)offset;
- (void)moveBottomToSuperview;

@property (nonatomic) CGFloat boundsX;
@property (nonatomic) CGFloat boundsY;
@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsHeight;
@property (nonatomic) CGSize boundsSize;

- (void)centerVerticallyInSuperview;
- (void)centerHorizontallyInSuperview;
- (void)centerInSuperview;

- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view;
- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view withOffset:(CGFloat)offset;

- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view;
- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view withOffset:(CGFloat)offset;

- (void)centerViewsHorizontally:(NSArray<UIView *> *)views;
- (void)centerViewsHorizontally:(NSArray<UIView *> *)views withMargin:(CGFloat)margin;

- (void)centerViewsVertically:(NSArray<UIView *> *)views;
- (void)centerViewsVertically:(NSArray<UIView *> *)views withMargin:(CGFloat)margin;

- (void)centerSubviewsVertically;
- (void)centerSubviewsVerticallyWithMargin:(CGFloat)margin;

- (void)centerSubviewsHorizontallyToSuperview;
- (void)centerSubviewsVerticallyToSuperview;

- (void)setAttr:(OSAttr)attr value:(CGFloat)value;
- (CGFloat)getAttrValue:(OSAttr)attr;

/// Only valid for OSAttrLeft, OSAttrRight, OSAttrTop, OSAttrBottom.
- (void)moveAttr:(OSAttr)attr value:(CGFloat)value;

/// Note: view at this moment, `view` should at the same level of hierarchy as self.
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge;
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge withOffset:(CGFloat)offset;

- (void)pinAttr:(OSAttr)attr toView:(UIView *)view attr:(OSAttr)viewAttr;
- (void)pinAttr:(OSAttr)attr toView:(UIView *)view;
- (void)pinAttr:(OSAttr)attr toView:(UIView *)view withOffset:(CGFloat)offset;
- (void)pinAttr:(OSAttr)attr toView:(UIView *)view attr:(OSAttr)viewAttr withOffset:(CGFloat)offset;

- (void)pinTopToViewBottom:(UIView *)view;
- (void)pinTopToViewBottom:(UIView *)view withOffset:(CGFloat)offset;
- (void)pinTopToSuperview;
- (void)pinTopToSuperviewWithOffset:(CGFloat)offset;
- (void)pinTopToControllerTopLayoutGuide:(UIViewController *)controller;
- (void)pinTopToControllerLayoutGuide:(UIViewController *)controller withOffset:(CGFloat)offset;

- (void)pinBottomToSuperview;
- (void)pinBottomToSuperviewWithOffset:(CGFloat)offset;
- (void)pinBottomToViewTop:(UIView *)view;
- (void)pinBottomToViewTop:(UIView *)view withOffset:(CGFloat)offset;

- (void)pinLeftToSuperview;
- (void)pinLeftToSuperviewWithOffset:(CGFloat)offset;
- (void)pinLeftToView:(UIView *)view;
- (void)pinLeftToView:(UIView *)view withOffset:(CGFloat)offset;
- (void)pinRightToSuperview;
- (void)pinRightToSuperviewWithOffset:(CGFloat)offset;
- (void)pinRightToView:(UIView *)view;
- (void)pinRightToView:(UIView *)view withOffset:(CGFloat)offset;

- (void)pinTopLeftToSuperview;
- (void)pinTopLeftToSuperviewWithOffset:(UIOffset)offset;
- (void)pinTopRightToSuperview;
- (void)pinTopRightToSuperviewWithOffset:(UIOffset)offset;
- (void)pinBottomLeftToSuperview;
- (void)pinBottomLeftToSuperviewWithOffset:(UIOffset)offset;
- (void)pinBottomRightToSuperview;
- (void)pinBottomRightToSuperviewWithOffset:(UIOffset)offset;

- (void)fitToSuperview;
- (void)fitToSuperviewWithInsets:(UIEdgeInsets)insets;
- (void)fitHorizontallyToSuperview;
- (void)fitHorizontallyToSuperviewWithInsets:(OSInsets)insets;
- (void)fitVerticallyToSuperview;
- (void)fitVerticallyToSuperviewWithInsets:(OSInsets)insets;

- (void)fitHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2;
- (void)fitHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withInsets:(OSInsets)offset;
- (void)fitVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2;
- (void)fitVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withInsets:(OSInsets)offset;
- (void)fitHorizontallyBetweenViewAndSuperview:(UIView *)view;
- (void)fitHorizontallyBetweenViewAndSuperview:(UIView *)view withInsets:(OSInsets)offset;
- (void)fitHorizontallyBetweenSuperviewAndView:(UIView *)view;
- (void)fitHorizontallyBetweenSuperviewAndView:(UIView *)view withInsets:(OSInsets)offset;
- (void)fitVerticallyBetweenSuperviewAndView:(UIView *)view;
- (void)fitVerticallyBetweenSuperviewAndView:(UIView *)view withInsets:(OSInsets)offset;
- (void)fitVerticallyBetweenViewAndSuperview:(UIView *)view;
- (void)fitVerticallyBetweenViewAndSuperview:(UIView *)view withInsets:(OSInsets)offset;

- (void)ensureFitsVerticallyToSuperview;
- (void)ensureFitsHorizontallyToSuperview;
- (void)ensureFitsToSuperview;

- (void)ensureFitsSubviewsMaxWidth;
- (void)ensureFitsSubviewsMaxHeight;

- (void)ensureWidthIsNoMoreThan:(CGFloat)maxWidth;
- (void)ensureHeightIsNoMoreThan:(CGFloat)maxHeight;

- (void)ensureRightIsNotCloserThan:(CGFloat)offset toView:(UIView *)view;
- (void)ensureLeftIsNotCloserThan:(CGFloat)offset toView:(UIView *)view;

/// Will adjust view's origin (if needed) to make it aligned with physical device pixels so
/// contents are not blurry because of possible inalignemnt.
- (void)fixOrigin;

+ (CGRect)boundingBoxForViews:(NSArray<UIView *> *)views;

+ (CGFloat)maxWidthForViews:(NSArray<UIView *> *)views;
- (CGFloat)maxWidthForSubviews;

+ (CGFloat)maxHeightForViews:(NSArray<UIView *> *)views;
- (CGFloat)maxHeightForSubviews;

- (void)sizeToFitAllSubviews;

@end
