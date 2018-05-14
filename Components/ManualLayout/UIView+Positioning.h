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
    OSAttrWidth,
    OSAttrHeight,
    OSAttrBoundsWidth,
    OSAttrBoundsHeight,
    OSAttrMovedLeft,
    OSAttrMovedRight,
    OSAttrMovedTop,
    OSAttrMovedBottom,
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

//-------------------------------------------------------------------------------------------
#pragma mark - Properties
//-------------------------------------------------------------------------------------------

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat side;

/// 'movedN' properties will change corresponding value by adjusting view dimensions instead of moving view origin.
@property (nonatomic) CGFloat movedX;
@property (nonatomic) CGFloat movedY;
@property (nonatomic) CGFloat movedRight;
@property (nonatomic) CGFloat movedBottom;
@property (nonatomic) CGPoint movedTopLeft;
@property (nonatomic) CGPoint movedTopRight;
@property (nonatomic) CGPoint movedBottomLeft;
@property (nonatomic) CGPoint movedBottomRight;

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGPoint bottomRight;

@property (nonatomic) CGFloat boundsX;
@property (nonatomic) CGFloat boundsY;
@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsHeight;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic, readonly) CGPoint boundsCenter;
@property (nonatomic, readonly) CGPoint frameCenter;

- (void)setAttr:(OSAttr)attr value:(CGFloat)value;
- (void)setAttr:(OSAttr)attr fromView:(UIView *)view;
- (CGFloat)getAttrValue:(OSAttr)attr;


//-------------------------------------------------------------------------------------------
#pragma mark - Moving
//-------------------------------------------------------------------------------------------

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

/// Only valid for OSAttrLeft, OSAttrRight, OSAttrTop, OSAttrBottom.
- (void)moveAttr:(OSAttr)attr value:(CGFloat)value;


//-------------------------------------------------------------------------------------------
#pragma mark - Fitting
//-------------------------------------------------------------------------------------------

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


//-------------------------------------------------------------------------------------------
#pragma mark - Ensuring
//-------------------------------------------------------------------------------------------

- (void)ensureFitsVerticallyToSuperview;
- (void)ensureFitsHorizontallyToSuperview;
- (void)ensureFitsToSuperview;

- (void)ensureFitsSubviewsMaxWidth;
- (void)ensureFitsSubviewsMaxHeight;

- (void)ensureWidthIsNoMoreThan:(CGFloat)maxWidth;
- (void)ensureHeightIsNoMoreThan:(CGFloat)maxHeight;

- (void)ensureLeftIsNotCloserThan:(CGFloat)offset toView:(UIView *)view;
- (void)ensureRightIsNotCloserThan:(CGFloat)offset toView:(UIView *)view;

- (void)ensureLeftIsNotCloserThanOffsetToSuperview:(CGFloat)offset;
- (void)ensureRightIsNotCloserThanOffsetToSuperview:(CGFloat)offset;

- (void)ensureMovedBottomIsNotCloserThan:(CGFloat)offset toView:(UIView *)view;
- (void)ensureMovedBottomIsNotCloserThanToSuperview:(CGFloat)offset;

//-------------------------------------------------------------------------------------------
#pragma mark - Centering
//-------------------------------------------------------------------------------------------

- (void)centerInSuperview;

- (void)centerHorizontallyInSuperview;
- (void)centerHorizontallyInSuperviewWithOffset:(CGFloat)offset;

- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view;
- (void)centerHorizontallyBetweenSuperviewAndView:(UIView *)view withOffset:(CGFloat)offset;

- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view;
- (void)centerHorizontallyBetweenViewAndSuperview:(UIView *)view withOffset:(CGFloat)offset;

- (void)centerHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withOffset:(CGFloat)offset;
- (void)centerHorizontallyBetweenView:(UIView *)view1 andView:(UIView *)view2;

- (void)centerVerticallyInSuperview;
- (void)centerVerticallyInSuperviewWithOffset:(CGFloat)offset;

- (void)centerVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2 withOffset:(CGFloat)offset;
- (void)centerVerticallyBetweenView:(UIView *)view1 andView:(UIView *)view2;

- (void)centerVerticallyBetweenSuperviewAndView:(UIView *)view;
- (void)centerVerticallyBetweenSuperviewAndView:(UIView *)view withOffset:(CGFloat)offset;

- (void)centerVerticallyBetweenViewAndSuperview:(UIView *)view;
- (void)centerVerticallyBetweenViewAndSuperview:(UIView *)view withOffset:(CGFloat)offset;

//-------------------------------------------------------------------------------------------
#pragma mark - Pinning
//-------------------------------------------------------------------------------------------

/// Note: view at this moment, `view` should at the same level of hierarchy as self.
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge;
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view edge:(OSEdge)viewEdge withOffset:(CGFloat)offset;
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view;
- (void)pinEdge:(OSEdge)edge toView:(UIView *)view withOffset:(CGFloat)offset;

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

//-------------------------------------------------------------------------------------------
#pragma mark - Subviews
//-------------------------------------------------------------------------------------------

- (void)subviewsSizeToFitAll;
- (void)subviewsSizeToFitWidthAll:(CGFloat)width;

- (void)subviewsStackAndCenterHorizontally:(NSArray<UIView *> *)views;
- (void)subviewsStackAndCenterHorizontally:(NSArray<UIView *> *)views withMargin:(CGFloat)margin;

- (void)subviewsStackAndCenterHorizontally;
- (void)subviewsStackAndCenterHorizontallyWithMargin:(CGFloat)margin;

- (void)subviewsStackAndCenterVertically:(NSArray<UIView *> *)views;
- (void)subviewsStackAndCenterVertically:(NSArray<UIView *> *)views withMargin:(CGFloat)margin;

- (void)subviewsStackAndCenterVertically;
- (void)subviewsStackAndCenterVerticallyWithMargin:(CGFloat)margin;

- (void)subviewsCenterHorizontallyToSuperview;
- (void)subviewsCenterVerticallyToSuperview;

- (void)subviewsDistributeHorizontally:(NSArray<UIView *> *)views spacing:(CGFloat)spacing insets:(OSInsets)insets;
- (void)subviewsDistributeHorizontally:(NSArray<UIView *> *)views spacing:(CGFloat)spacing;
- (void)subviewsDistributeHorizontally:(NSArray<UIView *> *)views insets:(OSInsets)insets;

- (void)subviewsDistributeHorizontallyWithSpacing:(CGFloat)margin insets:(OSInsets)insets;
- (void)subviewsDistributeHorizontallyWithSpacing:(CGFloat)margin;
- (void)subviewsDistributeHorizontallyWithInsets:(OSInsets)insets;

- (CGRect)subviewsBoundingBox:(NSArray<UIView *> *)views;
- (CGRect)subviewsBoundingBox;

- (CGFloat)subviewsMaxWidth:(NSArray<UIView *> *)views;
- (CGFloat)subviewsMaxWidth;

- (CGFloat)subviewsMaxHeight:(NSArray<UIView *> *)views;
- (CGFloat)subviewsMaxHeight;

- (CGFloat)subviewsMinAttrValue:(OSAttr)attr;
- (CGFloat)subviewsMaxAttrValue:(OSAttr)attr;

- (CGFloat)subviews:(NSArray<UIView *> *)views minAttrValue:(OSAttr)attr;
- (CGFloat)subviews:(NSArray<UIView *> *)views maxAttrValue:(OSAttr)attr;

//-------------------------------------------------------------------------------------------
#pragma mark - Utils
//-------------------------------------------------------------------------------------------

- (void)fixOrigin;

@end
