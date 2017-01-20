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
#import <TyphoonRestClient/TRCObjectMapper.h>

@class CCRestClient;

#define REGISTER_MAPPING + (void)load { [[CCRestClientRegistry defaultRegistry] addObjectMapperClass:self]; }

@interface CCMapping : NSObject <TRCObjectMapper>

+ (void)registerWithRestClient:(CCRestClient *)restClient;

@end
