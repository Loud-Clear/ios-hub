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

@import UIKit;


typedef NS_ENUM(NSInteger, CCStackViewOrientation) {
    CCStackViewOrientationVertical,
    CCStackViewOrientationHorizontal
};

typedef NS_ENUM(NSInteger, CCStackViewAlignment) {
    CCStackViewAlignmentNone,
    CCStackViewAlignmentLeading,
    CCStackViewAlignmentLeft = CCStackViewAlignmentLeading,
    CCStackViewAlignmentTop = CCStackViewAlignmentLeading,
    CCStackViewAlignmentCenter,
    CCStackViewAlignmentTrailing,
    CCStackViewAlignmentRight = CCStackViewAlignmentTrailing,
    CCStackViewAlignmentBottom = CCStackViewAlignmentLeading
};


@interface CCStackView : UIView

/// Default is CCStackViewOrientationVertical.
@property (nonatomic) CCStackViewOrientation orientation;

/// Default is CCStackViewAlignmentCenter.
@property (nonatomic) CCStackViewAlignment alignment;

/**
 *  `components` array should consist of the 3 following types: UIView`s, CCStackSpacing`s and NSNumber`s.
 *  UIView`s are views which should be added.
 *  CCStackSpacing`s represent spacing between views (absolute or relative).
 *  NSNumber`s is same as CCStackSpacing`s with absolute values.
 *
 *  @note CCStackView will not change dimensions of subviews during layout - only their positions.
 *  So you need to layout your subviews manually (only sizes, not positions - they will be managed by stack view).
 *
 *  @example
 *      stackView.frame = CGFrameMake(0, 0, 320, 200);
 *      stackView.components = @[ loginTextField, @10, emailTextField, @15, @loginButton ];
 *
 *   Given that loginTextField/emailTextField/loginButton all have height = 30, resulting distances between them will be:
 *   - loginTextField <-> emailTextField: 10/(10 + 15) * (200 - 3*30) = 44
 *   - emailTextField <-> loginButton: 15/(10 + 15) * (200 - 3*30) = 66
 *   It will look like:
 *     loginTextField
 *       <44px space>
 *     emailTextField
 *       <66px space>
 *     loginButton
 */
@property (nonatomic) NSArray *components;

- (CGFloat)layout;
- (CGSize)sizeThatFits;
- (void)sizeToFitWidth:(CGFloat)width;
- (void)sizeToFitHeight:(CGFloat)height;

@end


typedef NS_ENUM(NSInteger, CCStackSpacingKind) {
    CCStackSpacingKindAbsolute,
    CCStackSpacingKindRelative
};

@interface CCStackSpacing : NSObject

+ (instancetype)relative:(CGFloat)value;
+ (instancetype)absolute:(CGFloat)value;

@property (nonatomic) CCStackSpacingKind kind;
@property (nonatomic) NSNumber *value;

@property (nonatomic, readonly) CGFloat absoluteValue;

@end
