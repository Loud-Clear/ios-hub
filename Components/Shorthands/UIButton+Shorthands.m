////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIButton+Shorthands.h"

@implementation UIButton (Shorthands)

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

@end
