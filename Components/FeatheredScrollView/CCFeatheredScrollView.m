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

#import "CCFeatheredScrollView.h"

#import "EGOGradientView.h"

#import "UIColor+Components.h"


@interface CCFeatheredScrollView ()<UIScrollViewDelegate>
@end

@implementation CCFeatheredScrollView
{
    EGOGradientView *_topFeatherView, *_rightFeatherView, *_bottomFeatherView, *_leftFeatherView;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _featherBackgroundColor = [UIColor whiteColor];
        _featherHeight = 10;
        [self setupScrollView];
    }
    return self;
}

- (void)setupScrollView
{
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [super addSubview:_scrollView];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)configureWithPositions:(CCFeatheredScrollViewPosition)positions color:(UIColor *)featherBackgroundColor featherHeight:(CGFloat)featherHeight
{
    NSParameterAssert(featherBackgroundColor);
    NSParameterAssert(featherHeight != 0);

    _positions = positions;
    _featherBackgroundColor = featherBackgroundColor;
    _featherHeight = featherHeight;

    [self recreateFeatherViews];
}

- (void)addSubview:(UIView *)view
{
    [_scrollView addSubview:view];
}

- (void)updateFeathers
{
    CGFloat topAlpha = 1;

    if (_scrollView.contentOffset.y < _featherHeight) {
        if (_scrollView.contentOffset.y < 0) {
            topAlpha = 0;
        } else {
            topAlpha = _scrollView.contentOffset.y / _featherHeight;
        }
    }

    _topFeatherView.alpha = topAlpha;


    CGFloat bottomAlpha = 1;
    CGFloat bottomOffset = _scrollView.contentSize.height - _scrollView.contentOffset.y - _scrollView.height;

    if (bottomOffset < _featherHeight) {
        if (bottomOffset < 0) {
            bottomAlpha = 0;
        } else {
            bottomAlpha = bottomOffset / _featherHeight;
        }
    }

    _bottomFeatherView.alpha = bottomAlpha;
}

//-------------------------------------------------------------------------------------------
#pragma mark - <UIScrollViewDelegate>
//-------------------------------------------------------------------------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateFeathers];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;

    _topFeatherView.frame = CGRectMake(0, 0, self.width, _featherHeight);
    _bottomFeatherView.frame = CGRectMake(0, self.height - _featherHeight, self.width, _featherHeight);

    [self updateFeathers];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)recreateFeatherViews
{
    [_topFeatherView removeFromSuperview];
    _topFeatherView = nil;
    [_rightFeatherView removeFromSuperview];
    _rightFeatherView = nil;
    [_bottomFeatherView removeFromSuperview];
    _bottomFeatherView = nil;
    [_leftFeatherView removeFromSuperview];
    _leftFeatherView = nil;

    UIColor *transparentColor = [UIColor colorWithRed:_featherBackgroundColor.red green:_featherBackgroundColor.green blue:_featherBackgroundColor.blue alpha:0];

    if (_positions & CCFeatheredScrollViewPositionTop) {
        _topFeatherView = [EGOGradientView new];
        _topFeatherView.colors = @[_featherBackgroundColor, transparentColor];
        [super addSubview:_topFeatherView];
    }

    if (_positions & CCFeatheredScrollViewPositionBottom) {
        _bottomFeatherView = [EGOGradientView new];
        _bottomFeatherView.colors = @[_featherBackgroundColor, transparentColor];
        _bottomFeatherView.startPoint = CGPointMake(0.5, 1);
        _bottomFeatherView.endPoint = CGPointMake(0.5, 0);
        [super addSubview:_bottomFeatherView];
    }

    [self updateFeathers];
    [self setNeedsLayout];
}


@end
