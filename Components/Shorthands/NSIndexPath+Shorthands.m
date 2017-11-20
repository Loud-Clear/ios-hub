////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 14.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSIndexPath+Shorthands.h"


@implementation NSIndexPath (Shorthands)

+ (instancetype)withRow:(NSInteger)row
{
    return [NSIndexPath indexPathForRow:row inSection:0];
}

@end
