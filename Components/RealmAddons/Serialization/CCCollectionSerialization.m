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

#import "CCCollectionSerialization.h"


@implementation NSDictionary (CCCollectionSerialization)

- (id)serializeToJSONObject
{
    return self;
}

- (id)initWithJSONObject:(id)jsonObject
{
    NSAssert(!jsonObject || [jsonObject isKindOfClass:[NSDictionary class]], @"Incorrect type for %@", jsonObject);
    self = [self initWithDictionary:jsonObject];
    return self;
}

@end

@implementation NSArray (CCCollectionSerialization)

- (id)serializeToJSONObject
{
    return self;
}

- (id)initWithJSONObject:(id)jsonObject
{
    NSAssert(!jsonObject || [jsonObject isKindOfClass:[NSArray class]], @"Incorrect type for %@", jsonObject);
    self = [self initWithArray:jsonObject];
    return self;
}

@end
