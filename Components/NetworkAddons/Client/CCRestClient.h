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
#import "TyphoonRestClient.h"

@class CCConnectionLogger;


@interface CCRestClient : TyphoonRestClient

- (void)setupClient;

@property (nonatomic) NSURL *baseUrl;
@property (nonatomic) BOOL logging;

@property (nonatomic) id<TRCConnection> rawConnection;
@property (nonatomic) TRCConnectionProxy *connectionProxy;
@property (nonatomic) TRCConnectionProxy *sessionInjectingConnection __deprecated_msg("Deprecated - Use `connectionProxy`");

@property (nonatomic) BOOL shouldLogUploadProgress;
@property (nonatomic) BOOL shouldLogDownloadProgress;


/** Methods to override */

- (CCConnectionLogger *)connectionLoggerForConnection:(id<TRCConnection>)connection;
+ (NSURLSessionConfiguration *)urlSessionConfiguration;

@end
