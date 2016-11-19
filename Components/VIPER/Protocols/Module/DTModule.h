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

#import <UIKit/UIKit.h>

/**
 * Represents single VIPER-based UI module
 * */
@protocol DTModule <NSObject>

/**
 * Provides ability to setup Module by configuring it's input.
 * return type conforms protocol for your ModuleInput (and usually it conforms DTGeneralModuleInput)
 * */
- (id)moduleInput;

/**
 * Returns UIViewController subclass to present to user. (i.e. Push to navigation stack or use it's view)
 * */
- (UIViewController *)asViewController;

/**
 * Returns UIView subclass which you can add as subview
 * */
- (UIView *)asView;

@end
