////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Typhoon/TyphoonComponentFactory.h>
#import "CCGeneralWorkflow.h"
#import "CCMacroses.h"

NSString *const CCGeneralWorkflowWillStartNotification = @"CCGeneralWorkflowWillStartNotification";
NSString *const CCGeneralWorkflowDidFinishNotification = @"CCGeneralWorkflowDidFinishNotification";


@implementation CCGeneralWorkflow
{
    id _target;
    SEL _action;

    id _failureTarget;
    SEL _failureAction;

    id _backoutTarget;
    SEL _backoutAction;

    __weak UIViewController *_initialViewController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(CCModuleFactory)];
    }

    return self;
}

- (UIViewController *)newInitialViewController
{
    NSAssert(NO, @"newInitialViewController is not implemented. Please override in subclass");
    return nil;
}


- (UIViewController *)initialViewController
{
    [self workflowWillStart];

    UIViewController *initial = [self newInitialViewController];
    _initialViewController = initial;
    return initial;
}

- (void)setCompleteTarget:(id)target withAction:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setFailureTarget:(id)target withAction:(SEL)action
{
    _failureTarget = target;
    _failureAction = action;
}

- (void)setBackoutTarget:(id)target withAction:(SEL)action
{
    _backoutTarget = target;
    _backoutAction = action;
}

- (void)completeWithLastViewController:(UIViewController *)lastController
{
    SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS
    [_target performSelector:_action withObject:lastController];
    SUPPRESS_WARNING_END

    [self workflowDidFinish];
}

- (void)completeWithLastViewController:(UIViewController *)lastViewController context:(id)context
{
    SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS
    [_target performSelector:_action withObject:lastViewController withObject:context];
    SUPPRESS_WARNING_END

    [self workflowDidFinish];
}

- (void)failWithLastViewController:(UIViewController *)lastController error:(NSError *)error
{
    SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS
    [_failureTarget performSelector:_failureAction withObject:lastController withObject:error];
    SUPPRESS_WARNING_END

    [self workflowDidFinish];
}

- (void)backoutFromInitialViewController:(UIViewController *)lastController
{
    if (lastController == _initialViewController) {
        SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS
        [_backoutTarget performSelector:_backoutAction withObject:lastController];
        SUPPRESS_WARNING_END
    }
    [self workflowDidFinish];
}

// Workflow lifecycle

- (void)workflowWillStart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CCGeneralWorkflowWillStartNotification object:self];
}

- (void)workflowDidFinish
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CCGeneralWorkflowDidFinishNotification object:self];
}


@end
