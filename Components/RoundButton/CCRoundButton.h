//
// Created by Nikita Nagaynik on 29/11/2016.
// Copyright (c) 2016 Loud & Clear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRoundButton : UIButton

@property (nonatomic, assign) IBInspectable BOOL hideBorder;
@property (nonatomic, assign) IBInspectable BOOL inverseHighlight;
@property (nonatomic, assign) IBInspectable BOOL opaqueTitle;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, strong) UIFont *customFont;
@property (nonatomic, strong) UIColor *customTextColor;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithIcon:(UIImage *)icon;

@end
