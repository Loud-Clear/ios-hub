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

@import UIKit;

@interface UIButton (Shorthands)

+ (instancetype)withTarget:(id)target action:(SEL)action;

@property (nonatomic) NSString *title;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *backgroundImage;
@property (nonatomic) UIFont *titleFont;


@end
