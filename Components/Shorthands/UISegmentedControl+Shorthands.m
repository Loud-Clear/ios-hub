////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 31.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UISegmentedControl+Shorthands.h"


@implementation UISegmentedControl (Shorthands)

+ (instancetype)withItems:(nullable NSArray *)items
{
    return [[self alloc] initWithItems:items];
}

@end
