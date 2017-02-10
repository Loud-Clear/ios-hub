////////////////////////////////////////////////////////////////////////////////
//
//  LOUDCLEAR
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of LoudClear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "CCRequest.h"

@class TyphoonRestClient;
@class TyphoonComponentFactory;

//-------------------------------------------------------------------------------------------
#pragma mark - Post Processor
//-------------------------------------------------------------------------------------------

@interface CCRealmPostProcessor : NSObject

+ (void)registerWithRestClient:(TyphoonRestClient *)restClient typhoonFactory:(TyphoonComponentFactory *)factory;

@end

//-------------------------------------------------------------------------------------------
#pragma mark - Request params
//-------------------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, CCSaveMode) {
    CCSaveModeInsertOrReplace = 0,
    CCSaveModeInsertOrUpdate  = 1,
};

//TODO: Find a way to specify per-request CCSaveMode for post-processor