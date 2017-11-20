////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 31.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIBarButtonItem+Shorthands.h"


@implementation UIBarButtonItem (Shorthands)

+ (instancetype)withImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:image
                                            style:style
                                           target:target
                                           action:action];
}

+ (instancetype)withImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self withImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype)withCustomView:(UIView *)customView
{
    return [[self alloc] initWithCustomView:customView];
}

@end
