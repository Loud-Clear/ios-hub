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

#import <objc/runtime.h>
#import "UIViewController+CCTransitionHandler.h"
#import "CCModuleFactoryImplementation.h"
#import "TyphoonComponentFactory.h"
#import "CCTransitionPromise.h"
#import "CCWorkflow.h"
#import "CCNavigator.h"
#import "CCDisplayManager.h"
#import "CCMacroses.h"
#import "UIViewController+CCTransition.h"
#import "UIViewController+CCWorkflow.m"


static void(*originalPrepareForSegueMethodImp)(id, SEL, UIStoryboardSegue *, id);
static void(*originalViewWillDissappear)(id, SEL, BOOL);

@protocol CCTraditionalViperViewWithOutput<NSObject>
- (id)output;
@end

static void CCViperPrepareForSegueSender(id self, SEL selector, UIStoryboardSegue *segue, id sender);

@implementation UIViewController (CCTransitionHandler)

//-------------------------------------------------------------------------------------------
#pragma mark - Interface methods
//-------------------------------------------------------------------------------------------

- (id<CCModulePromise>)openModuleUsingSegue:(NSString *)segueIdentifier
{
    CCTransitionPromise *openModulePromise = [CCTransitionPromise new];
    SafetyCallOn(MainQueue, ^{
        [self performSegueWithIdentifier:segueIdentifier sender:openModulePromise];
    });

    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url
{
    return [self openModuleUsingURL:url transition:CCTransitionStyleAutomatic];
}

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url transitionBlock:(CCTransitionBlock)transitionBlock
{
    id<CCModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] transitionBlock:transitionBlock];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url segueClass:(Class)segueClass
{
    id<CCModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] segueClass:segueClass];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<CCModulePromise>)openModuleUsingURL:(NSURL *)url transition:(CCTransitionStyle)style
{
    id<CCModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] transition:style];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (void)closeCurrentModule:(BOOL)animated
{
    BOOL isInNavigationStack = [self.parentViewController isKindOfClass:[UINavigationController class]];
    BOOL hasManyControllersInStack = isInNavigationStack ? ((UINavigationController *)self.parentViewController).childViewControllers.count > 1 : NO;

    if (isInNavigationStack && hasManyControllersInStack) {
        UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
        [navigationController popViewControllerAnimated:animated];
    }
    else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.view.superview != nil) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}

- (id<CCModulePromise>)openWorkflow:(id<CCWorkflow>)workflow transition:(CCTransitionStyle)style
{
    id<CCModulePromise> openModulePromise = [self openViewController:[workflow initialViewController] transition:style];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (void)completeCurrentWorkflow
{
    [self.workflow completeWithLastViewController:self];
}

- (void)completeCurrentWorkflowWithFailure:(NSError *)error
{
    [self.workflow failWithLastViewController:self error:error];
}

- (void)completeCurrentWorkflowWithObject:(id)object
{
    [self.workflow completeWithLastViewController:self context:object];
}

- (void)navigateToURL:(NSURL *)url context:(CCNavigatorContext *)context  withAnimation:(CCDisplayManagerTransitionAnimation)animation
{
    CCNavigator *navigator = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:[CCNavigator class]];

    [CCDisplayManager animateChange:^{
        [CCTransitionHandler performWithoutAnimation:^{
            [UIView performWithoutAnimation:^{
                [navigator navigateToURL:url fromController:self context:context];
            }];
        }];
     } onWindow:[[UIApplication sharedApplication] keyWindow] withAnimtion:animation];
}

- (BOOL)canNavigateToURL:(NSURL *)url
{
    CCNavigator *navigator = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:[CCNavigator class]];
    return url && [navigator canNavigateToURL:url fromController:self];
}

//-------------------------------------------------------------------------------------------
#pragma mark - ModuleInput
//-------------------------------------------------------------------------------------------

- (id)moduleInput
{
    id result = GetAssociatedObject(@selector(moduleInput));
    if (!result && [self respondsToSelector:@selector(output)]) {
        result = [(id<CCTraditionalViperViewWithOutput>)self output];
    }
    if (!result && [self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (id)self;
        result = [navigation.topViewController moduleInput];
    }

    return result;
}

- (void)setModuleInput:(id<CCGeneralModuleInput>)moduleInput
{
    SetAssociatedObject(@selector(moduleInput), moduleInput);
}

//-------------------------------------------------------------------------------------------
#pragma mark - PrepareForSegue Swizzling
//-------------------------------------------------------------------------------------------

+ (void)initialize
{
    [self swizzlePrepareForSegue];
    [self swizzleViewWillDisappear];
}

+ (void)swizzlePrepareForSegue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP reamplerPrepareForSegueImp = (IMP)CCViperPrepareForSegueSender;

        Method prepareForSegueMethod = class_getInstanceMethod([self class], @selector(prepareForSegue:sender:));
        originalPrepareForSegueMethodImp = (void (*)(id, SEL, UIStoryboardSegue *, id))method_setImplementation(prepareForSegueMethod, reamplerPrepareForSegueImp);
    });
}

static void CCViperPrepareForSegueSender(id self, SEL selector, UIStoryboardSegue *segue, id sender)
{
    originalPrepareForSegueMethodImp(self, selector, segue, sender);

    if (![sender isKindOfClass:[CCTransitionPromise class]]) {
        return;
    }

    CCTransitionPromise *openModulePromise = sender;
    openModulePromise.nextViewController = segue.destinationViewController;
    openModulePromise.moduleInput = [segue.destinationViewController moduleInput];
}

+ (void)swizzleViewWillDisappear
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP reimplViewWillDissappear = (IMP)CCViperViewWillDissappear;
        
        Method viewWillDisappearMethod = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
        originalViewWillDissappear = (void (*)(id, SEL, BOOL))method_setImplementation(viewWillDisappearMethod, reimplViewWillDissappear);
    });
}

static void CCViperViewWillDissappear(id<CCWorkflow> self, SEL selector, BOOL animated)
{
    UIViewController *controller = (UIViewController*)self;
    
    if ([controller isBeingDismissed] || [controller isMovingFromParentViewController]) {
        //view is being dismissed due to back press or -(void)closeCurrentModule
        [controller.workflow backoutFromInitialViewController:controller];
    }
    
    originalViewWillDissappear(controller, selector, animated);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utils
//-------------------------------------------------------------------------------------------

- (UIViewController<CCTransitionHandler> *)viewControllerFromURL:(NSURL *)url
{
    id<CCModuleFactory> moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(CCModuleFactory)];
    id<CCModule> module = [moduleFactory moduleForURL:url];
    return [module asViewController];
}

- (id<CCModulePromise>)promiseByWorkflowLinkingInPromise:(id<CCModulePromise>)promise
{
    if ([promise isKindOfClass:[CCTransitionPromise class]] && self.workflow) {
        CCTransitionPromise *transitionPromise = (id)promise;
        [transitionPromise addPostLinkBlock:^(id input, UIViewController *next){
            if (!next.workflow) {
                next.workflow = self.workflow;
            }
        }];
    }
    return promise;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Shorthands
//-------------------------------------------------------------------------------------------

- (id<CCModulePromise>)openUrl:(NSString *)url
{
    return [self openModuleUsingURL:[NSURL URLWithString:url]];
}

- (id<CCModulePromise>)openUrl:(NSString *)url transitionBlock:(CCTransitionBlock)block
{
    return [self openModuleUsingURL:[NSURL URLWithString:url] transitionBlock:block];
}

- (id<CCModulePromise>)openUrl:(NSString *)url segueClass:(Class)segueClass
{
    return [self openModuleUsingURL:[NSURL URLWithString:url] segueClass:segueClass];
}

- (id<CCModulePromise>)openUrl:(NSString *)url transition:(CCTransitionStyle)style
{
    return [self openModuleUsingURL:[NSURL URLWithString:url] transition:style];
}

- (id<CCModulePromise>)openSegue:(NSString *)segueIdentifier
{
    return [self openModuleUsingSegue:segueIdentifier];
}


@end
