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

#import "CCModulePromise.h"
#import "CCModule.h"

@protocol CCModuleFactory<NSObject>

/**
 * This method creates module for specified URL
 *
 * Possible URL values:
 *
 * app:///<controller class>.class
 * - Returns module with specified class for viewController (Example: 'app:///CCWelcomeViewController.class')
 *
 * app:///<storyboard name>.storyboard
 * - Returns module with initial viewController from specified storyboard (Example: 'app:///Entry.storyboard')
 *
 * app:///<storyboard name>
 * - Same as <storyboard name>.storyboard (Example: 'app:///Entry')
 *
 * app:///<storyboard name>/<controller identifier>
 * - Returns module with specified viewController identifier from specified storyboard
 *   ( Example: 'app:///Entry/Welcome', where Welcome is storyboardIdentifier )
 *
 * app:///<viper module name>.module
 * - Returns module with specified VIPER module name (the name you used to generate it)
 *   ( Example: 'app:///Welcome.module' )
 *
 * http://<remote resource> or https://<remote resource>
 * - Returns module with internal UIWebView to present URL
 *
 * Optionally you can pass query parameters (as usual URL), then they'll be passed as NSDictionary and injected
 * into moduleInput's setInputParameters method (@see CCGeneralModuleInput for reference)
 *
 * Query parameters usually useful when you want to use URL as link inside label (@see CCLinkLabel), or inside WebPage,
 * or you want to store URL to disk.
 * In other cases it's better to pass module parameters inside CCModuleLinkBlock, using moduleInput
 * */

- (id<CCModule>)moduleForURL:(NSURL *)url;

- (id<CCModule>)moduleForURL:(NSURL *)url thenChainUsingBlock:(CCModuleLinkBlock)block;


/** Shorthands */

- (id<CCModule>)moduleFor:(NSString *)urlString;
- (id<CCModule>)moduleFor:(NSString *)urlString thenChainUsingBlock:(CCModuleLinkBlock)block;

@end
