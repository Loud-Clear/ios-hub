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

#import "CCEnvironment+SwitcherUI.h"
#import "CCEnvironmentListViewController.h"
#import "CCEnvironmentHUD.h"


@implementation CCEnvironment (SwitcherUI)

+ (void)showSwitcherOn:(UIViewController *)viewController
{
    CCEnvironmentListViewController *listViewController = [CCEnvironmentListViewController new];
    listViewController.environment = [self currentEnvironment];
    [viewController presentViewController:listViewController animated:YES completion:^{}];
}

+ (void)installStatusBarHUD
{
    [[CCEnvironmentHUD sharedHUD] setupWithEnvironment:[self currentEnvironment]];
}


@end
