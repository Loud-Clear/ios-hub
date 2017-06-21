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

#import "CCDisplayManager.h"
#import "TyphoonComponentFactory.h"
#import "UIViewController+CCTransitionHandler.h"
#import "CCWorkflow.h"
#import "MTTimingFunctions.h"
#import <UIView+MTAnimation.h>
#import "CCMacroses.h"
#import "CCModule.h"


@implementation CCDisplayManager

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (void)setupWindow:(UIWindow *)window factory:(TyphoonComponentFactory *)factory
{
    NSParameterAssert(self.initialWorkflow);

    [self setupWindow:window factory:factory viewController:[self.initialWorkflow initialViewController]];
}

- (void)setupWindow:(UIWindow *)window factory:(TyphoonComponentFactory *)factory viewController:(UIViewController *)viewController
{
    _window = window;
    _factory = factory;

    _window.rootViewController = viewController;
    [_window makeKeyAndVisible];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)replaceRootViewControllerWith:(UIViewController *)viewController animation:(CCDisplayManagerTransitionAnimation)animation
{
    void(^change)() = ^{
        _window.rootViewController = viewController;
    };
    
    [CCDisplayManager animateChange:change onWindow:self.window withAnimtion:animation];
}

- (id <CCModulePromise>)openModuleWithURL:(NSURL *)url transition:(CCTransitionStyle)style
{
    return [_window.rootViewController openModuleUsingURL:url transition:style];
}

- (id<CCModulePromise>)openModule:(id<CCModule>)module transition:(CCTransitionStyle)style
{
    return [self.rootViewController openModule:module transition:style];
}

+ (void)animateChange:(void (^)())change onWindow:(UIWindow *)window withAnimtion:(CCDisplayManagerTransitionAnimation)animation
{
    if (animation == CCDisplayManagerTransitionAnimationNone) {
        SafetyCall(change);
    } else if (animation == CCDisplayManagerTransitionAnimationPush) {
        CGFloat duration = 0.55;
        UIView *snapShot = [window snapshotViewAfterScreenUpdates:YES];

        UIView *darkenView = [[UIView alloc] initWithFrame:snapShot.bounds];
        darkenView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [snapShot addSubview:darkenView];

        SafetyCall(change);

        [[window.rootViewController.view superview] insertSubview:snapShot atIndex:0];

        CGRect frame = window.rootViewController.view.frame;
        frame.origin.x = frame.size.width;
        window.rootViewController.view.frame = frame;


        [UIView mt_animateWithViews:@[window.rootViewController.view, snapShot, darkenView]
                           duration:duration
                     timingFunction:MTTimingFunctionEaseOutExpo animations:^{
                    CGRect snapshotFrame = snapShot.frame;
                    snapshotFrame.origin.x = -snapShot.frame.size.width / 3;
                    snapShot.frame = snapshotFrame;

                    CGRect rootControllerFrame = window.rootViewController.view.frame;
                    rootControllerFrame.origin.x = 0;
                    window.rootViewController.view.frame = rootControllerFrame;
                }        completion:^{
                    [snapShot removeFromSuperview];
                }];

        [UIView animateWithDuration:duration animations:^{
            darkenView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        }];

        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    } else {
        [CATransaction begin];

        SafetyCall(change);

        CATransition *transition = [CATransition animation];

        transition.duration = 0.3f;
        switch (animation) {
        default:
        case CCDisplayManagerTransitionAnimationSlideUp:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            break;
        case CCDisplayManagerTransitionAnimationSlideDown:
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromBottom;;
            break;
        }
        transition.fillMode = kCAFillModeForwards;

        transition.removedOnCompletion = YES;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

        [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });

        [CATransaction commit];
    };
}

- (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

- (CGRect)screenBounds
{
    CGSize screenSize = [self screenSize];
    return CGRectMake(0, 0, screenSize.width, screenSize.height);
}

- (CGRect)windowFrame
{
    return [UIScreen mainScreen].bounds;
}

- (UIViewController *)rootViewController
{
    return self.window.rootViewController;
}


@end
