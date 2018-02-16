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
#import "CCMacroses.h"


@implementation CCRestClient
{
    __weak CCConnectionLogger *_logger;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (void)setupClient
{
    self.querySerializationOptions = TRCSerializerHttpQueryOptionsIncludeArrayIndices;

    [self setupConnection];
    [self registerComponents];
}

- (void)setupConnection
{
    if (!_rawConnection) {
        _rawConnection = [self makeDefaultRawConnection];
    }

    id<TRCConnection> connection = _rawConnection;

    if (_connectionProxy) {
        _connectionProxy.connection = connection;
        connection = self.connectionProxy;
    }

    if (_logging) {
        CCConnectionLogger *logger = [self connectionLoggerForConnection:connection];
        logger.shouldLogUploadProgress = self.shouldLogUploadProgress;
        logger.shouldLogDownloadProgress = self.shouldLogDownloadProgress;
        connection = logger;
        _logger = logger;
    }

    self.connection = connection;
}

- (id<TRCConnection> )makeDefaultRawConnection
{
    let rawConnection = [[TRCConnectionNSURLSession alloc] initWithBaseUrl:self.baseUrl configuration:[[self class] urlSessionConfiguration]];
    if ([rawConnection respondsToSelector:@selector(startReachabilityMonitoring)]) {
        [rawConnection performSelector:@selector(startReachabilityMonitoring)];
    }
    return rawConnection;
}

- (void)registerComponents
{
    [[CCRestClientRegistry defaultRegistry] registerAllWithRestClient:self];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Methods to override
//-------------------------------------------------------------------------------------------

- (CCConnectionLogger *)connectionLoggerForConnection:(id<TRCConnection>)connection
{
    return [[CCConnectionLogger alloc] initWithConnection:connection];
}

+ (NSURLSessionConfiguration *)urlSessionConfiguration
{
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    urlSessionConfiguration.timeoutIntervalForResource = 120;
    urlSessionConfiguration.timeoutIntervalForRequest = 120;

    return urlSessionConfiguration;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)setBaseUrl:(NSURL *)baseUrl
{
    _baseUrl = baseUrl;

    if ([_rawConnection respondsToSelector:@selector(setBaseUrl:)]) {
        [_rawConnection performSelector:@selector(setBaseUrl:) withObject:baseUrl];
    }
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

- (TRCConnectionProxy *)sessionInjectingConnection
{
    return self.connectionProxy;
}

- (void)setSessionInjectingConnection:(TRCConnectionProxy *)sessionInjectingConnection
{
    self.connectionProxy = sessionInjectingConnection;
}

@end
