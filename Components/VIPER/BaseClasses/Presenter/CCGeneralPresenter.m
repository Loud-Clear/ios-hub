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


@implementation CCGeneralPresenter
{
    BOOL _isViewReady;
    BOOL _isPresenterReady;
}

- (void)didConfigureModule
{
    _isPresenterReady = YES;
    [self trySetupModule];
}

- (void)didTriggerViewReadyEvent
{
    _isViewReady = YES;
    [self trySetupModule];
}

- (void)trySetupModule
{
    if (_isViewReady && _isPresenterReady) {
        [self setupModule];
    }
}

- (void)setupModule
{

}

@end
