////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCRestClientRegistry.h"
#import "CCRestClient.h"
#import "CCMapping.h"


@implementation CCRestClientRegistry
{
    NSMutableSet *_mappers;
    NSMutableSet *_valueTransformers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mappers = [NSMutableSet new];
        _valueTransformers = [NSMutableSet new];
    }
    return self;
}

+ (instancetype)defaultRegistry
{
    static CCRestClientRegistry *registry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    	registry = [CCRestClientRegistry new];
    });
    return registry;
}

- (void)addObjectMapperClass:(Class)clazz
{
    [_mappers addObject:clazz];
}

- (void)addValueTransformerClass:(Class)clazz
{
    [_valueTransformers addObject:clazz];
}

- (void)registerAllWithRestClient:(CCRestClient *)restClient
{
    for (Class clazz in _mappers) {
        [clazz registerWithRestClient:restClient];
    }
    for (Class clazz in _valueTransformers) {
        [clazz registerWithRestClient:restClient];
    }

}


@end
