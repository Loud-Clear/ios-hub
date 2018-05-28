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
    __weak TRCConnectionNSURLSession *_networkConnection;
    id<TRCConnection> _initialConnection;
    CCConnectionLogger *_loggerConnection;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithConnection:(id<TRCConnection>)connection
{
    self = [super init];
    if (self) {
        _initialConnection = connection;
        _networkConnection = [self findNetworkConnectionFrom:_initialConnection];
        NSAssert(_networkConnection, @"Can't find underlaying network connection");
        _loggerConnection = [self connectionLoggerForConnection:_initialConnection];
    }
    return self;
}

- (void)setupClient
{
    self.querySerializationOptions = TRCSerializerHttpQueryOptionsIncludeArrayIndices;
    [self registerComponents];
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

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)setBaseUrl:(NSURL *)baseUrl
{
    _baseUrl = baseUrl;
    _networkConnection.baseUrl = baseUrl;
}

- (void)setLogging:(BOOL)logging
{
    _logging = logging;
    if (_logging) {
        self.connection = _loggerConnection;
    } else {
        self.connection = _initialConnection;
    }
}

- (void)setShouldLogDownloadProgress:(BOOL)shouldLogDownloadProgress
{
    _loggerConnection.shouldLogDownloadProgress = shouldLogDownloadProgress;
    _shouldLogDownloadProgress = shouldLogDownloadProgress;
}

- (void)setShouldLogUploadProgress:(BOOL)shouldLogUploadProgress
{
    _loggerConnection.shouldLogUploadProgress = shouldLogUploadProgress;
    _shouldLogUploadProgress = shouldLogUploadProgress;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private
//-------------------------------------------------------------------------------------------

// Looks through underlaying connections and find for real network connection
// Returns network connection or nil, if can't find it
- (TRCConnectionNSURLSession *)findNetworkConnectionFrom:(id<TRCConnection>)connection
{
    if ([self isNetworkConnection:connection]) {
        return connection;
    } else if ([connection isKindOfClass:[TRCConnectionProxy class]]) {
        TRCConnectionProxy *proxy = (id)connection;
        return [self findNetworkConnectionFrom:proxy.connection];
    }
    return nil;
}

- (BOOL)isNetworkConnection:(id<TRCConnection>)connection
{
    return [connection respondsToSelector:@selector(setBaseUrl:)];
}

@end
