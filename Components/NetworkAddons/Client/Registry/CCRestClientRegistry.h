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

#import <Foundation/Foundation.h>

@class CCRestClient;


@interface CCRestClientRegistry : NSObject

+ (instancetype)defaultRegistry;

- (void)addObjectMapperClass:(Class)clazz;

- (void)addValueTransformerClass:(Class)clazz;

- (void)registerAllWithRestClient:(CCRestClient *)restClient;

@end
