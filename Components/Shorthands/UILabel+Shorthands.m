////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 18.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UILabel+Shorthands.h"
#import "CCMacroses.h"


@implementation UILabel (Shorthands)

+ (instancetype)withFont:(UIFont *)font color:(UIColor *)color
{
    let label = [UILabel new];
    label.font = font;
    label.textColor = color;
    return label;
}

@end
