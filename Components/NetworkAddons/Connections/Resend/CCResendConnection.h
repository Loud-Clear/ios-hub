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

extern NSString *CCResendConnectionShouldResend;

@interface CCResendConnection : TRCConnectionProxy

@property (nonatomic) NSInteger maxResendAttempts; //Default 3


@end
