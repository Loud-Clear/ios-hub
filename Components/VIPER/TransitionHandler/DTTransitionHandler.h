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

#import "DTModulePromise.h"
#import "DTDisplayManagerAnimation.h"

@protocol DTGeneralModuleInput;
@protocol DTWorkflow;
@class DTNavigatorContext;

typedef void(^DTTransitionBlock)(UIViewController *source, UIViewController *destination);

typedef NS_ENUM(NSInteger, DTTransitionStyle)
{
    DTTransitionStyleAutomatic = 0, //Either push or modal
    DTTransitionStyleModal,
    DTTransitionStylePush,
    DTTransitionStylePushAsRoot,
    DTTransitionStyleReplaceRoot
};


@protocol DTTransitionHandler<NSObject>

@property (nonatomic, strong) id<DTGeneralModuleInput> moduleInput;

/**
 * Opens module using segue within current storyboard
 * */
- (id<DTModulePromise>)openModuleUsingSegue:(NSString *)segueIdentifier;

/**
 * Navigates to next module, found by URL
 *
 * Possible URL values:
 *
 * app:///<controller class>.class
 * - Returns module with specified class for viewController (Example: 'app:///DTWelcomeViewController.class')
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
 * into moduleInput's setInputParameters method (@see DTGeneralModuleInput for reference)
 *
 * Query parameters usually useful when you want to use URL as link inside label (@see DTLinkLabel), or inside WebPage,
 * or you want to store URL to disk.
 * In other cases it's better to pass module parameters inside DTModuleLinkBlock, using moduleInput
 * */
- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url;

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url transitionBlock:(DTTransitionBlock)block;

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url segueClass:(Class)segueClass;

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url transition:(DTTransitionStyle)style;


///
///
///
- (void)navigateToURL:(NSURL *)url context:(DTNavigatorContext *)context withAnimation:(DTDisplayManagerTransitionAnimation)animation;

// Returns YES, if found route from current ViewController
- (BOOL)canNavigateToURL:(NSURL *)url;

/**
 * Method removes/closes module
 * */
- (void)closeCurrentModule:(BOOL)animated;

/**
 * Workflows
 * */

- (id<DTModulePromise>)openWorkflow:(id<DTWorkflow>)workflow transition:(DTTransitionStyle)style;

- (void)completeCurrentWorkflow;

- (void)completeCurrentWorkflowWithObject:(id)object;

- (void)completeCurrentWorkflowWithFailure:(NSError *)error;

@end

@interface DTTransitionHandler : NSObject

+ (void)performWithoutAnimation:(void(^)())transitions;

@end
