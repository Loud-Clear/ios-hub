//
//  CCValidationErrorToBugfenderPostProcessor.m
//  YoMojo
//
//  Created by Aleksey Garbarev on 08/06/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TyphoonRestClient/TyphoonRestClientErrors.h>
#import "CCValidationErrorToBugfenderPostProcessor.h"
#import "TRCRequest.h"
#import "NSError+CCTableFormManager.h"
#import "CCMacroses.h"

@protocol CCBugfenderClass <NSObject>

- (void)sendIssueWithTitle:(NSString *)title text:(NSString *)text;

@end

@implementation CCValidationErrorToBugfenderPostProcessor

- (BOOL)shouldReportError:(NSError *)responseError forRequest:(id<TRCRequest>)request
{
    return [responseError.domain isEqualToString:TyphoonRestClientErrors] && responseError.code == TyphoonRestClientErrorCodeValidation;
}

- (NSError *)postProcessError:(NSError *)responseError forRequest:(id<TRCRequest>)request
{
    if ([self shouldReportError:responseError forRequest:request]) {
        NSString *title = [NSString stringWithFormat:@"Response Validation Failure (/%@)", [request path]];
        NSString *body = [NSString stringWithFormat:@"***%@***\n\nIncorrect response:\n```%@\n```", responseError.localizedDescription, responseError.userInfo[TyphoonRestClientErrorKeyFullDescription]];
        DDLogError(@"Response Validation Error(/%@): %@", [request path], responseError.localizedDescription);
        [[self bugfenderClass] sendIssueWithTitle:title text:body];
        return [NSError errorWithLocalizedDescription:@"Server returned unexpected result. Issue reported."];
    }

    return responseError;
}

- (TRCQueueType)queueType
{
    return TRCQueueTypeCallback;
}

- (id<CCBugfenderClass>)bugfenderClass
{
    return (id)NSClassFromString(@"Bugfender");
}


@end
