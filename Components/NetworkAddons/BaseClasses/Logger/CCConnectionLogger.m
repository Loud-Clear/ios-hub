////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCConnectionLogger.h"
#import "CCRequest.h"


@implementation CCConnectionLogger
{

}

- (id<TRCProgressHandler>)sendRequest:(NSURLRequest *)request
                          withOptions:(id<TRCConnectionRequestSendingOptions>)options
                           completion:(TRCConnectionCompletion)completion
{

    //Optional disable logging
    if ([options.customProperties[kCCRequestDisableLoggingCustomFlagKey] boolValue]) {
        return [self.connection sendRequest:request withOptions:options completion:completion];
    }

    return [super sendRequest:request withOptions:options completion:completion];
}


@end