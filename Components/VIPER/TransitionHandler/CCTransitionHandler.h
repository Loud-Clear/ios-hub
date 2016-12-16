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

#import "CCModulePromise.h"
#import "CCDisplayManagerAnimation.h"

@protocol CCGeneralModuleInput;
@protocol CCWorkflow;
@class CCNavigatorContext;

typedef void(^ССTransitionBlock)(UIViewController *source, UIViewController *destination);

typedef NS_ENUM(NSInteger, ССTransitionStyle)
{
    ССTransitionStyleAutomatic = 0, //Either push or modal
    ССTransitionStyleModal,
    ССTransitionStylePush,
    ССTransitionStylePushAsRoot,
    ССTransitionStyleReplaceRoot
};


@protocol CCTransitionHandler<NSObject>

@property (nonatomic, strong) id<CCGeneralModuleInput> moduleInput;

/**
 * Opens module using segue within current storyboard
 * */
- (id<CCModulePromise>)openModuleUsingSegue:(NSString *)segueIdentifier;

/**
 * Navigates to next module, found by URL
 *
 * Possible URL values:
 *
 * app:///<controller class>.class
 * - Returns module with specified class for viewController (Example: 'app:///ССWelcomeViewController.class')
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
 * into moduleInput's setInputParameters method (@see ССGeneralModuleInput for reference)
 *
 * Query parameters usually useful when you want to use URL as link inside label (@see ССLinkLabel), or inside WebPage,
 * or you want to store URL to disk.
 * In other cases it's better to pass module parameters inside ССModuleLinkBlock, using moduleInput
 * */
- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url;

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url transitionBlock:(ССTransitionBlock)block;

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url segueClass:(Class)segueClass;

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url transition:(ССTransitionStyle)style;

/**
 * Method removes/closes module
 * */
- (void)closeCurrentModule:(BOOL)animated;

/**
 * Custom navigation using CCNavigator class. You should register CCNavigator instance definition in your Typhoon assembly,
 * before using these methods
 * */
- (void)navigateToURL:(NSURL *)url context:(CCNavigatorContext *)context withAnimation:(CCDisplayManagerTransitionAnimation)animation;

// Returns YES, if found route from current ViewController
- (BOOL)canNavigateToURL:(NSURL *)url;

/**
 * Workflow support
 * */

- (id<CCModulePromise>)openWorkflow:(id<CCWorkflow>)workflow transition:(ССTransitionStyle)style;

- (void)completeCurrentWorkflow;

- (void)completeCurrentWorkflowWithObject:(id)object;

- (void)completeCurrentWorkflowWithFailure:(NSError *)error;


/**
 *  Shorthands
 *  Discussion: maybe we should deprecate long versions of these ones, since signature matches
 * */

- (id<CCModulePromise>)openUrl:(NSString *)url;

- (id<CCModulePromise>)openUrl:(NSString *)url transitionBlock:(ССTransitionBlock)block;

- (id<CCModulePromise>)openUrl:(NSString *)url segueClass:(Class)segueClass;

- (id<CCModulePromise>)openUrl:(NSString *)url transition:(ССTransitionStyle)style;

- (id<CCModulePromise>)openSegue:(NSString *)segueIdentifier;

@end

@interface ССTransitionHandler : NSObject

+ (void)performWithoutAnimation:(void(^)())transitions;

@end
