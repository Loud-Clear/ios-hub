////////////////////////////////////////////////////////////////////////////////
//
//  VAMPR
//  Copyright 2015 Vampr Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Vampr. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;

typedef NS_ENUM(NSUInteger, CCFeatheredScrollViewPosition)
{
    CCFeatheredScrollViewPositionTop = 1 << 0,
    CCFeatheredScrollViewPositionRight = 1 << 1,
    CCFeatheredScrollViewPositionBottom = 1 << 2,
    CCFeatheredScrollViewPositionLeft = 1 << 3,
    CCFeatheredScrollViewPositionsVertical = CCFeatheredScrollViewPositionTop | CCFeatheredScrollViewPositionBottom,
    CCFeatheredScrollViewPositionsHorizontal = CCFeatheredScrollViewPositionRight | CCFeatheredScrollViewPositionLeft,
};

@interface CCFeatheredScrollView : UIView

- (void)configureWithPositions:(CCFeatheredScrollViewPosition)positions color:(UIColor *)featherBackgroundColor featherHeight:(CGFloat)featherHeight;

@property (nonatomic, readonly) CGFloat featherHeight;
@property (nonatomic, readonly) CCFeatheredScrollViewPosition positions;
@property (nonatomic, readonly) UIColor *featherBackgroundColor;

@property (nonatomic, readonly) UIScrollView *scrollView;

- (void)updateFeathers;

@end
