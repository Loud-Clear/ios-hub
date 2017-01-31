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

#import "CCRestClient.h"
#import "CCRestClientRegistry.h"


@implementation CCRestClient {
    TRCConnectionNSURLSession *_rawConnection;
}

- (void)setupClient
{
    self.querySerializationOptions = TRCSerializerHttpQueryOptionsIncludeArrayIndices;

    [self setupConnection];
    [self registerComponents];
}

- (void)setupConnection
{
    _rawConnection = [[TRCConnectionNSURLSession alloc] initWithBaseUrl:self.baseUrl configuration:[[self class] urlSessionConfiguration]];
    [_rawConnection startReachabilityMonitoring];

    id<TRCConnection> connection = _rawConnection;

    NSParameterAssert(self.sessionInjectingConnection);
    self.sessionInjectingConnection.connection = connection;
    connection = self.sessionInjectingConnection;

    if (self.logging) {
        TRCConnectionLogger *logger = [[TRCConnectionLogger alloc] initWithConnection:connection];
        logger.shouldLogUploadProgress = NO;
        logger.shouldLogDownloadProgress = NO;
        connection = logger;
    }

    self.connection = connection;
}

- (void)setBaseUrl:(NSURL *)baseUrl
{
    _baseUrl = baseUrl;
    _rawConnection.baseUrl = baseUrl;
}

+ (NSURLSessionConfiguration *)urlSessionConfiguration
{
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    urlSessionConfiguration.timeoutIntervalForResource = 120;
    urlSessionConfiguration.timeoutIntervalForRequest = 120;

    return urlSessionConfiguration;
}

- (void)registerComponents
{
    [[CCRestClientRegistry defaultRegistry] registerAllWithRestClient:self];
}

@end
