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
#import "CCRestClient+Environment.h"

@class CCConnectionLogger;


@interface CCRestClient : TyphoonRestClient

- (void)setupClient;

@property (nonatomic) NSURL *baseUrl;

// Logging
@property (nonatomic) BOOL logging;
@property (nonatomic) BOOL shouldLogUploadProgress;
@property (nonatomic) BOOL shouldLogDownloadProgress;

@property (nonatomic) NSString *debugName;

- (instancetype)initWithConnection:(id<TRCConnection>)connection;

/** Methods to override */

- (CCConnectionLogger *)connectionLoggerForConnection:(id<TRCConnection>)connection;
+ (NSURLSessionConfiguration *)urlSessionConfiguration;

@end
