//
//  CCFormPostProcessorExcludeValues.m
//  DreamTeam
//
//  Created by Артем Морозенок on 6/28/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCFormPostProcessorExcludeValues.h"

@implementation CCFormPostProcessorExcludeValues

- (void)postProcessData:(NSMutableDictionary<NSString *, id> *)mutableData
{
    for (NSString *key in self.namesToExclude) {
        [mutableData removeObjectForKey:key];
    }
}

+ (instancetype)withFieldsArray:(NSArray *)array
{
    CCFormPostProcessorExcludeValues *filter = [CCFormPostProcessorExcludeValues new];
    filter.namesToExclude = array;
    return filter;
}

@end
