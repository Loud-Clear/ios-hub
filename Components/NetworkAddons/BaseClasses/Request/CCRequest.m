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

#import "CCRequest.h"

NSString *kCCRequestRequiresSessionCustomFlagKey = @"requiresSession";
NSString *kCCRequestDisableLoggingCustomFlagKey = @"disableLogging";

@implementation CCRequest

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (BOOL)requiresSession
{
    return YES;
}

- (BOOL)disableLogging
{
    return NO;
}

- (BOOL)disableCache
{
    return NO;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Required Methods
//-------------------------------------------------------------------------------------------

- (NSString *)path
{
    return @"/";
}

- (TRCRequestMethod)method
{
    return TRCRequestMethodGet;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Request Methods
//-------------------------------------------------------------------------------------------

- (id)requestBody
{
    return @{};
}

- (TRCSerialization)requestBodySerialization
{
    return TRCSerializationJson;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Response Methods
//-------------------------------------------------------------------------------------------

- (NSMutableURLRequest *)requestPostProcessedFromRequest:(NSMutableURLRequest *)request
{
    if ([self disableCache]) {
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    return request;
}

- (TRCSerialization)responseBodySerialization
{
    return TRCSerializationJson;
}

- (id)responseProcessedFromBody:(NSDictionary *)bodyDict headers:(NSDictionary *)responseHeaders
                         status:(TRCHttpStatusCode)statusCode error:(NSError **)parseError
{
    return bodyDict;
}

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

- (NSDictionary *)customProperties
{
    NSMutableDictionary *customProperties = [NSMutableDictionary new];
    if ([self requiresSession]) {
        customProperties[kCCRequestRequiresSessionCustomFlagKey] = @YES;
    }
    if ([self disableLogging]) {
        customProperties[kCCRequestDisableLoggingCustomFlagKey] = @YES;
    }
    return customProperties;
}

@end
