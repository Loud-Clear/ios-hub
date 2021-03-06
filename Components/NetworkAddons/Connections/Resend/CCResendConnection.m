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
#import "CCResendConnection.h"
#import "CCMutableCollections.h"
#import "CCMacroses.h"

@implementation CCResendConnection {
    NSDictionary *_errorCodeToString;

    NSSet *_errorCodesToResend;
}

static NSString * CCResendConnectionAttempts = @"resend-attempts";
NSString * const CCResendConnectionShouldResend = @"should-resend";

- (instancetype)initWithConnection:(id<TRCConnection>)connection
{
    self = [super initWithConnection:connection];
    if (self) {
        _errorCodesToResend = [NSSet setWithArray:@[
                @(NSURLErrorNetworkConnectionLost),
                @(NSURLErrorNotConnectedToInternet),
                @(NSURLErrorUnknown)
        ]];
        _errorCodeToString = @{
                @(NSURLErrorUnknown): @"NSURLErrorUnknown",
                @(NSURLErrorCancelled): @"NSURLErrorCancelled",
                @(NSURLErrorBadURL): @"NSURLErrorBadURL",
                @(NSURLErrorTimedOut): @"NSURLErrorTimedOut",
                @(NSURLErrorUnsupportedURL): @"NSURLErrorUnsupportedURL",
                @(NSURLErrorCannotFindHost): @"NSURLErrorCannotFindHost",
                @(NSURLErrorCannotConnectToHost): @"NSURLErrorCannotConnectToHost",
                @(NSURLErrorNetworkConnectionLost): @"NSURLErrorNetworkConnectionLost",
                @(NSURLErrorDNSLookupFailed): @"NSURLErrorDNSLookupFailed",
                @(NSURLErrorHTTPTooManyRedirects): @"NSURLErrorHTTPTooManyRedirects",
                @(NSURLErrorResourceUnavailable): @"NSURLErrorResourceUnavailable",
                @(NSURLErrorNotConnectedToInternet): @"NSURLErrorNotConnectedToInternet",
                @(NSURLErrorRedirectToNonExistentLocation): @"NSURLErrorRedirectToNonExistentLocation",
                @(NSURLErrorBadServerResponse): @"NSURLErrorBadServerResponse",
                @(NSURLErrorUserCancelledAuthentication): @"NSURLErrorUserCancelledAuthentication",
                @(NSURLErrorUserAuthenticationRequired): @"NSURLErrorUserAuthenticationRequired",
                @(NSURLErrorZeroByteResource): @"NSURLErrorZeroByteResource",
                @(NSURLErrorCannotDecodeRawData): @"NSURLErrorCannotDecodeRawData",
                @(NSURLErrorCannotDecodeContentData): @"NSURLErrorCannotDecodeContentData",
                @(NSURLErrorCannotParseResponse): @"NSURLErrorCannotParseResponse",
                @(NSURLErrorAppTransportSecurityRequiresSecureConnection): @"NSURLErrorAppTransportSecurityRequiresSecureConnection",
                @(NSURLErrorFileDoesNotExist): @"NSURLErrorFileDoesNotExist",
                @(NSURLErrorFileIsDirectory): @"NSURLErrorFileIsDirectory",
                @(NSURLErrorNoPermissionsToReadFile): @"NSURLErrorNoPermissionsToReadFile",
                @(NSURLErrorDataLengthExceedsMaximum): @"NSURLErrorDataLengthExceedsMaximum",
                @(NSURLErrorFileOutsideSafeArea): @"NSURLErrorFileOutsideSafeArea",
                @(NSURLErrorSecureConnectionFailed): @"NSURLErrorSecureConnectionFailed",
                @(NSURLErrorServerCertificateHasBadDate): @"NSURLErrorServerCertificateHasBadDate",
                @(NSURLErrorServerCertificateUntrusted): @"NSURLErrorServerCertificateUntrusted",
                @(NSURLErrorServerCertificateHasUnknownRoot): @"NSURLErrorServerCertificateHasUnknownRoot",
                @(NSURLErrorServerCertificateNotYetValid): @"NSURLErrorServerCertificateNotYetValid",
                @(NSURLErrorClientCertificateRejected): @"NSURLErrorClientCertificateRejected",
                @(NSURLErrorClientCertificateRequired): @"NSURLErrorClientCertificateRequired",
                @(NSURLErrorCannotLoadFromNetwork): @"NSURLErrorCannotLoadFromNetwork",
                @(NSURLErrorCannotCreateFile): @"NSURLErrorCannotCreateFile",
                @(NSURLErrorCannotOpenFile): @"NSURLErrorCannotOpenFile",
                @(NSURLErrorCannotCloseFile): @"NSURLErrorCannotCloseFile",
                @(NSURLErrorCannotWriteToFile): @"NSURLErrorCannotWriteToFile",
                @(NSURLErrorCannotRemoveFile): @"NSURLErrorCannotRemoveFile",
                @(NSURLErrorCannotMoveFile): @"NSURLErrorCannotMoveFile",
                @(NSURLErrorDownloadDecodingFailedMidStream): @"NSURLErrorDownloadDecodingFailedMidStream",
                @(NSURLErrorDownloadDecodingFailedToComplete): @"NSURLErrorDownloadDecodingFailedToComplete",
                @(NSURLErrorInternationalRoamingOff): @"NSURLErrorInternationalRoamingOff",
                @(NSURLErrorCallIsActive): @"NSURLErrorCallIsActive",
                @(NSURLErrorDataNotAllowed): @"NSURLErrorDataNotAllowed",
                @(NSURLErrorRequestBodyStreamExhausted): @"NSURLErrorRequestBodyStreamExhausted",
                @(NSURLErrorBackgroundSessionRequiresSharedContainer): @"NSURLErrorBackgroundSessionRequiresSharedContainer",
                @(NSURLErrorBackgroundSessionInUseByAnotherProcess): @"NSURLErrorBackgroundSessionInUseByAnotherProcess",
                @(NSURLErrorBackgroundSessionWasDisconnected): @"NSURLErrorBackgroundSessionWasDisconnected"
        };
        self.maxResendAttempts = 3;
    }
    return self;
}


- (id<TRCProgressHandler>)sendRequest:(NSURLRequest *)request
                          withOptions:(id<TRCConnectionRequestSendingOptions>)options
                           completion:(TRCConnectionCompletion)completion
{

    [self incrementAttemptInOptions:options];

    return [self.connection sendRequest:request
                            withOptions:options
                             completion:^(id responseObject, NSError *error, id<TRCResponseInfo> responseInfo) {

                                 CCResendDecision resendDecision = [self shouldResendRequest:request options:options withError:error responseInfo:responseInfo];
                                 
                                 BOOL hasUnusedAttempts = [self attemptsFromOptions:options] < (resendDecision.maxResendAttempts + 1);
                                 
                                 if (resendDecision.shouldResend && hasUnusedAttempts) {
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(resendDecision.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self sendRequest:request withOptions:options completion:completion];
                                     });
                                 } else {
                                     completion(responseObject, error, responseInfo);
                                 }
                             }];
}

- (CCResendDecision)shouldResendRequest:(NSURLRequest *)request options:(id<TRCConnectionRequestSendingOptions>)options withError:(NSError *)error responseInfo:(id<TRCResponseInfo>)responseInfo
{
    BOOL shouldResend = NO;
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        
        BOOL correctHTTPMethod = [request.HTTPMethod isEqualToString:TRCRequestMethodGet];
        BOOL correctErrorCode = [_errorCodesToResend containsObject:@(error.code)];
        BOOL shouldResendOption = [self shouldResendOptionFromOptions:options];
        
        shouldResend = (correctHTTPMethod && correctErrorCode) || shouldResendOption;
        
        DDLogWarn(@"Will %@resend, because Method=%@, ErrorCode=%@, Used attempts=%d (of %d)", shouldResend?@"":@"NOT ", request.HTTPMethod, _errorCodeToString[@(error.code)], (int)[self attemptsFromOptions:options]-1, (int)self.maxResendAttempts);
    }

    return (CCResendDecision){.shouldResend = shouldResend, .delay = 0, .maxResendAttempts = self.maxResendAttempts};
}

- (void)incrementAttemptInOptions:(id<TRCConnectionRequestSendingOptions>)options
{
    NSInteger attempts = [self attemptsFromOptions:options];

    NSMutableDictionary *dictionary = options.customProperties ? [options.customProperties mutableDictionary] : [NSMutableDictionary new];
    dictionary[CCResendConnectionAttempts] = @(attempts + 1);
    options.customProperties = dictionary;
}

- (NSInteger)attemptsFromOptions:(id<TRCConnectionRequestSendingOptions>)options
{
    return [options.customProperties[CCResendConnectionAttempts] integerValue];
}

- (BOOL)shouldResendOptionFromOptions:(id<TRCConnectionRequestSendingOptions>)options
{
    return [options.customProperties[CCResendConnectionShouldResend] boolValue];
}

@end
