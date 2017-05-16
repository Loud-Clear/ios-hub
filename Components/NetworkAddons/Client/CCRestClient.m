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
#import "CCConnectionLogger.h"


@implementation CCRestClient {
    TRCConnectionNSURLSession *_rawConnection;
    __weak CCConnectionLogger *_logger;
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
        CCConnectionLogger *logger = [self connectionLoggerForConnection:connection];
        logger.shouldLogUploadProgress = self.shouldLogUploadProgress;
        logger.shouldLogDownloadProgress = self.shouldLogDownloadProgress;
        connection = logger;
        _logger = logger;
    }

    self.connection = connection;
}

- (CCConnectionLogger *)connectionLoggerForConnection:(id<TRCConnection>)connection
{
    return [[CCConnectionLogger alloc] initWithConnection:connection];
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

- (void)setShouldLogDownloadProgress:(BOOL)shouldLogDownloadProgress
{
    _logger.shouldLogDownloadProgress = shouldLogDownloadProgress;
    _shouldLogDownloadProgress = shouldLogDownloadProgress;
}

- (void)setShouldLogUploadProgress:(BOOL)shouldLogUploadProgress
{
    _logger.shouldLogUploadProgress = shouldLogUploadProgress;
    _shouldLogUploadProgress = shouldLogUploadProgress;
}

@end
