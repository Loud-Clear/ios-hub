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

#import <Foundation/Foundation.h>
#import "CCEnvironment.h"
#import <UIKit/UIKit.h>

@interface CCEnvironment (SwitcherUI)

+ (void)showSwitcherOn:(UIViewController *)viewController;

// Call this method inside your didFinishLaunching method to get indication of current environment in statusBar
+ (void)installStatusBarHUD;

@end