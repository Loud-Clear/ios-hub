////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 26.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSArray+CCSorted.h"

@interface NSObject (CCComparable)
- (NSComparisonResult)compare:(id)other;
@end


@implementation NSArray (CCSorted)

- (instancetype)cc_sortedArray
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSObject *obj1, NSObject *obj2) {
        return [obj1 compare:obj2];
    }];
}

@end
