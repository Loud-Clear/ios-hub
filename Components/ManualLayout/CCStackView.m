////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2016 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCStackView.h"
#import "UIView+Positioning.h"
#import "CCUIRound.h"


@interface CCStackSpacing (Private)
@property (nonatomic) CGFloat absoluteValue;
@end


@implementation CCStackView

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _alignment = CCStackViewAlignmentCenter;

    return self;
}

- (void)setComponents:(NSArray *)components
{
    for (id component in _components) {
        if ([component isKindOfClass:[UIView class]]) {
            UIView *view = component;
            [view removeFromSuperview];
        }
    }

    _components = components;

    for (id component in _components) {
        if ([component isKindOfClass:[UIView class]]) {
            UIView *view = component;
            if (view.superview != self) {
                [self addSubview:view];
            }
        }
    }

    [self setNeedsLayout];
}

- (CGSize)sizeThatFits
{
    CGSize size = CGSizeZero;

    for (id component in _components) {
        if (_orientation == CCStackViewOrientationVertical) {
            if ([component isKindOfClass:[UIView class]]) {
                UIView *view = component;
                size.height += view.height;
                size.width = fmaxf(size.width, view.width);
            } else if ([component isKindOfClass:[CCStackSpacing class]] && ((CCStackSpacing *) component).kind == CCStackSpacingKindAbsolute) {
                CCStackSpacing *absoluteDistance = component;
                size.height += [absoluteDistance.value doubleValue];
            } else if ([component isKindOfClass:[NSNumber class]]) {
                NSNumber *distance = component;
                size.height += [distance doubleValue];
            }
        } else if (_orientation == CCStackViewOrientationHorizontal) {
            if ([component isKindOfClass:[UIView class]]) {
                UIView *view = component;
                size.width += view.width;
                size.height = fmaxf(size.height, view.height);
            } else if ([component isKindOfClass:[CCStackSpacing class]] && ((CCStackSpacing *) component).kind == CCStackSpacingKindAbsolute) {
                CCStackSpacing *absoluteDistance = component;
                size.width += [absoluteDistance.value doubleValue];
            } else if ([component isKindOfClass:[NSNumber class]]) {
                NSNumber *distance = component;
                size.width += [distance doubleValue];
            }
        } else {
            NSAssert(NO, nil);
        }
    }

    return size;
}

- (void)sizeToFitWidth:(CGFloat)width
{
    self.width = width;
    self.height = [self layout];
}

- (void)sizeToFitHeight:(CGFloat)height
{
    self.height = height;
    self.width = [self layout];
}

- (CGFloat)layout
{
    CGFloat totalRelativeSpacing = 0;
    CGFloat totalAbsoluteSpacing = 0;
    CGFloat totalViewsLength = 0;

    for (id component in _components) {

        if ([component isKindOfClass:[UIView class]]) {
            UIView *view = component;
            if (_orientation == CCStackViewOrientationVertical) {
                totalViewsLength += view.height;
            } else if (_orientation == CCStackViewOrientationHorizontal) {
                totalViewsLength += view.width;
            }
        } else if ([component isKindOfClass:[CCStackSpacing class]] && ((CCStackSpacing *) component).kind == CCStackSpacingKindAbsolute) {
            CCStackSpacing *absoluteSpacing = component;
            totalAbsoluteSpacing += [absoluteSpacing.value doubleValue];
        } else if ([component isKindOfClass:[CCStackSpacing class]] && ((CCStackSpacing *) component).kind == CCStackSpacingKindRelative) {
            CCStackSpacing *relativeSpacing = component;
            totalRelativeSpacing += [relativeSpacing.value doubleValue];
        } else if ([component isKindOfClass:[NSNumber class]]) {
            NSNumber *spacing = component;
            totalAbsoluteSpacing += [spacing doubleValue];
        }
    }

    CGFloat d = 0;
    for (id component in _components) {
        if ([component isKindOfClass:[UIView class]]) {
            UIView *view = component;
            d = CCUIRound(d);
            if (_orientation == CCStackViewOrientationVertical) {
                view.y = d;
                d += view.height;
            } else if (_orientation == CCStackViewOrientationHorizontal) {
                view.x = d;
                d += view.width;
            }

            if (_orientation == CCStackViewOrientationVertical) {
                if (_alignment == CCStackViewAlignmentCenter) {
                    [view centerHorizontallyInSuperview];
                } else if (_alignment == CCStackViewAlignmentTop) {
                    [view pinTopToSuperview];
                } else if (_alignment == CCStackViewAlignmentBottom) {
                    [view pinBottomToSuperview];
                }
            } else if (_orientation == CCStackViewOrientationHorizontal) {
                if (_alignment == CCStackViewAlignmentCenter) {
                    [view centerVerticallyInSuperview];
                } else if (_alignment == CCStackViewAlignmentLeft) {
                    [view pinLeftToSuperview];
                } else if (_alignment == CCStackViewAlignmentRight) {
                    [view pinRightToSuperview];
                }
            }
        } else if ([component isKindOfClass:[CCStackSpacing class]] || [component isKindOfClass:[NSNumber class]]) {
            CCStackSpacingKind kind = CCStackSpacingKindAbsolute;
            CGFloat spacingValue = 0;

            if ([component isKindOfClass:[CCStackSpacing class]]) {
                CCStackSpacing *spacing = component;
                spacingValue = [spacing.value floatValue];
                kind = spacing.kind;
            } else if ([component isKindOfClass:[NSNumber class]]) {
                NSNumber *spacing = component;
                spacingValue = [spacing floatValue];
                kind = CCStackSpacingKindAbsolute;
            }

            if (kind == CCStackSpacingKindAbsolute) {
                d += spacingValue;
            } else if (kind == CCStackSpacingKindRelative) {
                CGFloat totalViewLength = 0;
                if (_orientation == CCStackViewOrientationVertical) {
                    totalViewLength = self.height;
                } else if (_orientation == CCStackViewOrientationHorizontal) {
                    totalViewLength = self.width;
                }
                CGFloat inc = spacingValue / totalRelativeSpacing * (totalViewLength - totalViewsLength - totalAbsoluteSpacing);
                CCStackSpacing *spacing = component;
                spacing.absoluteValue = inc;
                d += inc;
            }
        }
    }

    return d;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layout];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

@end


@implementation CCStackSpacing

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)relative:(CGFloat)value
{
    return [[CCStackSpacing alloc] initWithKind:CCStackSpacingKindRelative value:value];
}

+ (instancetype)absolute:(CGFloat)value
{
    return [[CCStackSpacing alloc] initWithKind:CCStackSpacingKindAbsolute value:value];
}

- (instancetype)initWithKind:(CCStackSpacingKind)kind value:(CGFloat)value
{
    if (!(self = [super init])) {
        return nil;
    }

    _value = @(value);
    _kind = kind;

    return self;
}

- (void)setAbsoluteValue:(CGFloat)absoluteValue
{
    _absoluteValue = absoluteValue;
}

@end
