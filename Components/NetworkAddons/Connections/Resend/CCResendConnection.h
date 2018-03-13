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
#import "TRCConnectionProxy.h"

typedef struct {
    BOOL shouldResend;
    NSTimeInterval delay;
    NSInteger maxResendAttempts;
} CCResendDecision;

extern NSString *CCResendConnectionShouldResend;

@interface CCResendConnection : TRCConnectionProxy

@property (nonatomic) NSInteger maxResendAttempts; //Default 3

- (CCResendDecision)shouldResendRequest:(NSURLRequest *)request
                                options:(id<TRCConnectionRequestSendingOptions>)options
                              withError:(NSError *)error
                           responseInfo:(id<TRCResponseInfo>)responseInfo;

@end
