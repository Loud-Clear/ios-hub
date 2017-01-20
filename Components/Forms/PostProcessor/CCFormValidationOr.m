////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCFormValidationOr.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationOr

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)withPostProcessors:(NSArray<id<CCFormPostProcessor>> *)postProcessors
{
    return [self withPostProcessors:postProcessors message:@""];
}

+ (instancetype)withPostProcessors:(NSArray<id<CCFormPostProcessor>> *)postProcessors message:(NSString *)message
{
    NSParameterAssert(postProcessors && message);
    CCFormValidationOr *filter = [CCFormValidationOr new];
    filter.postProcessors = postProcessors;
    filter.message = message;
    return filter;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Protocol Methods
//-------------------------------------------------------------------------------------------

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    for (id<CCFormPostProcessor> postProcessor in _postProcessors) {
        if ([postProcessor respondsToSelector:@selector(validateData:error:)] && [postProcessor validateData:data error:error]) {
            return YES;
        }
    }

    if (error) {
        *error = [NSError errorWithLocalizedDescription:_message];
    }

    return NO;
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)key
{
    for (id<CCFormPostProcessor> postProcessor in _postProcessors) {
        if ([postProcessor respondsToSelector:@selector(shouldValidateAfterEndEditingName:)] &&
            [postProcessor shouldValidateAfterEndEditingName:key])
        {
            return YES;
        }
    }
    return NO;
}

@end
