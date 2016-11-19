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
#import "DTGeneralWorkflow.h"
#import "DTMacroses.h"

@implementation DTGeneralWorkflow
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
        _moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(DTModuleFactory)];
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
    SuppressPerformSelectorLeakWarning(
            [_target performSelector:_action withObject:lastController];
    );
}

- (void)completeWithLastViewController:(UIViewController *)lastViewController context:(id)context
{
    SuppressPerformSelectorLeakWarning(
            [_target performSelector:_action withObject:lastViewController withObject:context];
    );
}

- (void)failWithLastViewController:(UIViewController *)lastController error:(NSError *)error
{
    SuppressPerformSelectorLeakWarning(
            [_failureTarget performSelector:_failureAction withObject:lastController withObject:error];
    );
}

- (void)backoutFromInitialViewController:(UIViewController *)lastController
{
    if (lastController == _initialViewController)
    {
        SuppressPerformSelectorLeakWarning(
            [_backoutTarget performSelector:_backoutAction withObject:lastController];
        );
	}
}

@end