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

#import "DTDatabaseDictionary.h"

@interface DTDatabaseDictionary ()
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation DTDatabaseDictionary

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithJSONObject:dictionary];
}

- (id)initWithJSONObject:(id)jsonObject
{
    self = [super init];
    if (self) {
        NSAssert(!jsonObject || [jsonObject isKindOfClass:[NSDictionary class]], @"Incorrect type for %@", jsonObject);
        self.dictionary = jsonObject;
    }
    return self;
}

- (id)serializeToJSONObject
{
    return self.dictionary;
}

@end

@implementation NSDictionary (DTDatabaseSerialization)

- (id)serializeToJSONObject
{
    return self;
}

- (id)initWithJSONObject:(id)jsonObject
{
    self = [self initWithDictionary:jsonObject];
    return self;
}

@end
