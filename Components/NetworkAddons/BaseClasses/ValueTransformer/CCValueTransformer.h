////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class CCRestClient;

#define REGISTER_TRANSFORMER + (void)load { [[CCRestClientRegistry defaultRegistry] addValueTransformerClass:self]; }

@interface CCValueTransformer : NSObject

+ (void)registerWithRestClient:(CCRestClient *)restClient;

@end
