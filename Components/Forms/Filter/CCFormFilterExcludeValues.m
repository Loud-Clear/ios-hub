//
//  CCFormFilterExcludeValues.m
//  DreamTeam
//
//  Created by Артем Морозенок on 6/28/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCFormFilterExcludeValues.h"

@implementation CCFormFilterExcludeValues

- (void)filterFormData:(NSMutableDictionary<NSString *, id> *)formData validationError:(NSError **)error
{
    for (NSString *key in self.namesToExclude) {
        [formData removeObjectForKey:key];
    }
}

+ (instancetype)withArray:(NSArray *)array
{
    CCFormFilterExcludeValues *filter = [CCFormFilterExcludeValues new];
    filter.namesToExclude = array;
    return filter;
}


@end
