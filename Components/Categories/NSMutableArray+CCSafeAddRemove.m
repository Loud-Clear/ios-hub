////////////////////////////////////////////////////////////////////////////////
//
//  Fernwood
//  Created by ivan at 12.04.2018.
//
//  Copyright 2018 Loud & Clear Pty Ltd Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSMutableArray+CCSafeAddRemove.h"
#import "CCLogger.h"


@implementation NSMutableArray (CCSafeAddRemove)

- (void)cc_safeAddObject:(id)object
{
    if (!object) {
        DDLogWarn(@"Attempting to add nil object to array");
        return;
    }

    [self addObject:object];
}

- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        DDLogWarn(@"Attempting to remove object from array at invalid index (%@, count=%@).", @(index), @(self.count));
        return;
    }

    [self removeObjectAtIndex:index];
}

@end
