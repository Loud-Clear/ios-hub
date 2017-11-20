////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 31.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


@interface UIBarButtonItem (Shorthands)

+ (instancetype)withImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (instancetype)withImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)withCustomView:(UIView *)customView;


@end
