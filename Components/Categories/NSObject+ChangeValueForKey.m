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

#import "NSObject+ChangeValueForKey.h"
#import "CCMacroses.h"


@implementation NSObject (ChangeValueForKey)

- (void)cc_changeValueForKey:(NSString *)key block:(dispatch_block_t)block
{
    [self willChangeValueForKey:key];
    CCSafeCall(block);
    [self didChangeValueForKey:key];
}

- (void)cc_changeValueForKeys:(NSArray<NSString *> *)keys block:(dispatch_block_t)block
{
    for (NSString *key in keys) {
        [self willChangeValueForKey:key];
    }

    CCSafeCall(block);

    for (NSString *key in keys) {
        [self didChangeValueForKey:key];
    }
}

@end
