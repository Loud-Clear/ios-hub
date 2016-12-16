//
// Created by Nikita Nagaynik on 29/11/2016.
// Copyright (c) 2016 Loud & Clear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCRoundButtonRenderer;

@interface CCRoundButton : UIButton

@property (nonatomic, assign) IBInspectable BOOL inverseHighlight;
@property (nonatomic, assign) IBInspectable BOOL usesOpaqueContentWhenHighlighted;
@property (nonatomic) IBInspectable CGFloat borderWidth;

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state;
- (void)setFillColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImageTint:(UIColor *)color forState:(UIControlState)state;

@property (nonatomic, strong) id<CCRoundButtonRenderer> background;

- (void)setRightImage:(UIImage *)image forState:(UIControlState)state;

- (void)setLeftImage:(UIImage *)image forState:(UIControlState)state;

- (void)setRightImageOffset:(CGSize)rightOffset;

- (void)setLeftImageOffset:(CGSize)leftOffset;

@end

@protocol CCRoundButtonRenderer <NSObject>

- (void)drawInRect:(CGRect)rect forState:(UIControlState)state;

@end