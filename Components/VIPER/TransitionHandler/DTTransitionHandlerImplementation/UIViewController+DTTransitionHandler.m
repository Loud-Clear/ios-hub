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
#import "UIViewController+DTTransitionHandler.h"
#import "DTModuleFactoryImplementation.h"
#import "TyphoonComponentFactory.h"
#import "DTTransitionPromise.h"
#import "UIViewController+DTTransition.h"
#import "UIViewController+DTWorkflow.h"
#import "DTWorkflow.h"
#import "DTNavigator.h"
#import "DTDisplayManager.h"
#import "DTMacroses.h"

static void(*originalPrepareForSegueMethodImp)(id, SEL, UIStoryboardSegue *, id);
static void(*originalViewWillDissappear)(id, SEL, BOOL);

@protocol DTTraditionalViperViewWithOutput<NSObject>
- (id)output;
@end

static void DTViperPrepareForSegueSender(id self, SEL selector, UIStoryboardSegue *segue, id sender);

@implementation UIViewController (DTTransitionHandler)

//-------------------------------------------------------------------------------------------
#pragma mark - Interface methods
//-------------------------------------------------------------------------------------------

- (id<DTModulePromise>)openModuleUsingSegue:(NSString *)segueIdentifier
{
    DTTransitionPromise *openModulePromise = [DTTransitionPromise new];
    SafetyCallOn(MainQueue, ^{
        [self performSegueWithIdentifier:segueIdentifier sender:openModulePromise];
    });

    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url
{
    return [self openModuleUsingURL:url transition:DTTransitionStyleAutomatic];
}

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url transitionBlock:(DTTransitionBlock)transitionBlock
{
    id<DTModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] transitionBlock:transitionBlock];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url segueClass:(Class)segueClass
{
    id<DTModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] segueClass:segueClass];
    return [self promiseByWorkflowLinkingInPromise:openModulePromise];
}

- (id<DTModulePromise>)openModuleUsingURL:(NSURL *)url transition:(DTTransitionStyle)style
{
    id<DTModulePromise> openModulePromise = [self openViewController:[self viewControllerFromURL:url] transition:style];
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

- (id<DTModulePromise>)openWorkflow:(id<DTWorkflow>)workflow transition:(DTTransitionStyle)style
{
    id<DTModulePromise> openModulePromise = [self openViewController:[workflow initialViewController] transition:style];
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

- (void)navigateToURL:(NSURL *)url context:(DTNavigatorContext *)context  withAnimation:(DTDisplayManagerTransitionAnimation)animation
{
    DTNavigator *navigator = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:[DTNavigator class]];

    [DTDisplayManager animateChange:^{
        [DTTransitionHandler performWithoutAnimation:^{
            [UIView performWithoutAnimation:^{
                [navigator navigateToURL:url fromController:self context:context];
            }];
        }];
     } onWindow:[[UIApplication sharedApplication] keyWindow] withAnimtion:animation];
}

- (BOOL)canNavigateToURL:(NSURL *)url
{
    DTNavigator *navigator = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:[DTNavigator class]];
    return url && [navigator canNavigateToURL:url fromController:self];
}

//-------------------------------------------------------------------------------------------
#pragma mark - ModuleInput
//-------------------------------------------------------------------------------------------

- (id)moduleInput
{
    id result = GetAssociatedObject(@selector(moduleInput));
    if (!result && [self respondsToSelector:@selector(output)]) {
        result = [(id<DTTraditionalViperViewWithOutput>)self output];
    }
    if (!result && [self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (id)self;
        result = [navigation.topViewController moduleInput];
    }

    return result;
}

- (void)setModuleInput:(id<DTGeneralModuleInput>)moduleInput
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
        IMP reamplerPrepareForSegueImp = (IMP)DTViperPrepareForSegueSender;

        Method prepareForSegueMethod = class_getInstanceMethod([self class], @selector(prepareForSegue:sender:));
        originalPrepareForSegueMethodImp = (void (*)(id, SEL, UIStoryboardSegue *, id))method_setImplementation(prepareForSegueMethod, reamplerPrepareForSegueImp);
    });
}

static void DTViperPrepareForSegueSender(id self, SEL selector, UIStoryboardSegue *segue, id sender)
{
    originalPrepareForSegueMethodImp(self, selector, segue, sender);

    if (![sender isKindOfClass:[DTTransitionPromise class]]) {
        return;
    }

    DTTransitionPromise *openModulePromise = sender;
    openModulePromise.nextViewController = segue.destinationViewController;
    openModulePromise.moduleInput = [segue.destinationViewController moduleInput];
}

+ (void)swizzleViewWillDisappear
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP reimplViewWillDissappear = (IMP)DTViperViewWillDissappear;
        
        Method viewWillDisappearMethod = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
        originalViewWillDissappear = (void (*)(id, SEL, BOOL))method_setImplementation(viewWillDisappearMethod, reimplViewWillDissappear);
    });
}

static void DTViperViewWillDissappear(id<DTWorkflow> self, SEL selector, BOOL animated)
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

- (UIViewController<DTTransitionHandler> *)viewControllerFromURL:(NSURL *)url
{
    id<DTModuleFactory> moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(DTModuleFactory)];
    id<DTModule> module = [moduleFactory moduleForURL:url];
    return [module asViewController];
}

- (id<DTModulePromise>)promiseByWorkflowLinkingInPromise:(id<DTModulePromise>)promise
{
    if ([promise isKindOfClass:[DTTransitionPromise class]] && self.workflow) {
        DTTransitionPromise *transitionPromise = (id)promise;
        [transitionPromise addPostLinkBlock:^(id input, UIViewController *next){
            if (!next.workflow) {
                next.workflow = self.workflow;
            }
        }];
    }
    return promise;
}

@end
