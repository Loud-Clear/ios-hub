//
//  CCAssemblyCollector.m
//  ShoeboxTimeline
//
//  Created by Aleksey Garbarev on 21/11/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import "CCAssemblyCollector.h"

@implementation CCAssemblyCollector

static NSMutableArray *CCInitialAssemblyClasses;

+ (void)registerInitialAssemblyClass:(Class)clazz
{
    @synchronized (self) {
        if (!CCInitialAssemblyClasses) {
            CCInitialAssemblyClasses = [NSMutableArray new];
        }
        [CCInitialAssemblyClasses addObject:clazz];
    }
}

- (NSArray *)collectInitialAssemblyClasses
{
    return CCInitialAssemblyClasses;
}

@end
