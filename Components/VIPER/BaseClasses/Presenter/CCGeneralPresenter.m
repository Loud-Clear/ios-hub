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

#import "CCGeneralPresenter.h"
#import "CCMacroses.h"

@implementation CCGeneralPresenter
{
    BOOL _isViewReady;
    BOOL _isPresenterReady;
    
    BOOL _isModuleSetupCalled;
}

- (void)didConfigureModule
{
    _isPresenterReady = YES;
    [self trySetupModule];
}

- (void)didTriggerViewReadyEvent
{
    _isViewReady = YES;
    [self trySetupModuleWithTimeout:0];
}

- (void)trySetupModule
{
    if (_isViewReady && _isPresenterReady) {
        [self callSetupModuleIfNeeded];
    }
}

- (void)trySetupModuleWithTimeout:(NSTimeInterval)timeout
{
    if (_isViewReady && _isPresenterReady) {
        [self callSetupModuleIfNeeded];
    } else {
        SafetyCallAfter(timeout, ^{
            if (!_isModuleSetupCalled) {
                [self callSetupModuleIfNeeded];
            }
        });
    }
}

- (void)callSetupModuleIfNeeded
{
    if (!_isModuleSetupCalled) {
        [self setupModule];
        _isModuleSetupCalled = YES;
    }
}

- (void)setupModule
{

}

@end
