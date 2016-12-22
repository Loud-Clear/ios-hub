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

#import <Foundation/Foundation.h>
#import <TyphoonRestClient/TyphoonRestClient.h>

@protocol TRCResponseTrigger;


@interface TyphoonRestClientStub : TyphoonRestClient

- (id<TRCResponseTrigger>)stubRequest:(Class)requestClass;

- (void)stubRequest:(Class)requestClass withResponse:(id)object error:(NSError *)error;

- (void)stubWithResponseObject:(id)object error:(NSError *)error;

- (void)verifyRequestWithBlock:(void(^)(id<TRCRequest>request))block;

- (void)verifyFirstRequestWithBlock:(void(^)(id<TRCRequest>request))block;

@end

@protocol TRCResponseTrigger <NSObject>

- (void)responseWith:(id)object error:(NSError *)error;

@end
