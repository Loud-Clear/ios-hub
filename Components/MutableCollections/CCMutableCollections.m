////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCMutableCollections.h"


@implementation NSDictionary (MutableDictionary)

- (NSMutableDictionary *)mutableDictionary
{
    if ([[self class] isKindOfClass:[NSMutableDictionary class]]) {
        return (id)self;
    }

    return [[NSMutableDictionary alloc] initWithDictionary:self];
}

@end


@implementation NSArray (MutableArray)

- (NSMutableArray  *)mutableArray
{
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return (id)self;
    } else {
        return [NSMutableArray arrayWithArray:self];
    }
}

@end
