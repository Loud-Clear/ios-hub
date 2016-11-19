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

#import "DTDisplayManager.h"
#import "TyphoonComponentFactory.h"
#import "UIViewController+DTTransitionHandler.h"
#import "DTWorkflow.h"
#import "MTTimingFunctions.h"
#import "ССNotificationUtils.h"
#import <UIView+MTAnimation.h>
#import <Aspects/Aspects.h>
#import "DTMacroses.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation DTDisplayManager

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (void)setupWindow:(UIWindow *)window factory:(TyphoonComponentFactory *)factory
{
    NSParameterAssert(self.initialWorkflow);

    _window = window;
    _factory = factory;

    [self registerForNotification:UIDeviceOrientationDidChangeNotification selector:@selector(deviceOrientationDidChangeNotification)];

    if (self.shouldEmulateIPhoneOnIPad && IS_IPAD) {
        [self setupIphoneEmulationOnIpad];
    }

    _window.rootViewController = [self.initialWorkflow initialViewController];
    [_window makeKeyAndVisible];
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)replaceRootViewControllerWith:(UIViewController *)viewController animation:(DTDisplayManagerTransitionAnimation)animation
{
    [DTDisplayManager animateChange:^{
                _window.rootViewController = viewController;
            }
                           onWindow:self.window
                       withAnimtion:animation];
}

- (id <DTModulePromise>)openModuleWithURL:(NSURL *)url transition:(DTTransitionStyle)style
{
    return [_window.rootViewController openModuleUsingURL:url transition:style];
}

+ (void)animateChange:(void (^)())change onWindow:(UIWindow *)window withAnimtion:(DTDisplayManagerTransitionAnimation)animation
{
    if (animation == DTDisplayManagerTransitionAnimationNone) {
        SafetyCall(change);
    } else if (animation == DTDisplayManagerTransitionAnimationPush) {
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
        case DTDisplayManagerTransitionAnimationSlideUp:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            break;
        case DTDisplayManagerTransitionAnimationSlideDown:
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
    if (self.shouldEmulateIPhoneOnIPad && IS_IPAD) {
        // Emulate iPhone 6+ size.
        return CGSizeMake(414, 736);
    } else {
        return [UIScreen mainScreen].bounds.size;
    }
}

- (CGRect)screenBounds
{
    CGSize screenSize = [self screenSize];
    return CGRectMake(0, 0, screenSize.width, screenSize.height);
}

- (CGRect)windowFrame
{
    if (self.shouldEmulateIPhoneOnIPad && IS_IPAD) {
        CGSize desiredScreenSize = [self screenSize];
        CGSize realScreenSize = [UIScreen mainScreen].bounds.size;
        CGRect windowFrame = CGRectMake(
                (realScreenSize.height - desiredScreenSize.height) / 2,
                (realScreenSize.width - desiredScreenSize.width) / 2,
                desiredScreenSize.height,
                desiredScreenSize.width);
        return windowFrame;
    } else {
        return [UIScreen mainScreen].bounds;
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - UIDeviceOrientation notifications
//-------------------------------------------------------------------------------------------

- (void)deviceOrientationDidChangeNotification
{
    if (self.shouldEmulateIPhoneOnIPad && IS_IPAD) {
        [self adjustWindowAndRootControllerLayoutForIphoneEmulation];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (CGRect)realScreenBoundsFixed
{
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if ((isLandscape && (screenBounds.size.width < screenBounds.size.height)))
    {
        screenBounds = CGRectMake(screenBounds.origin.y, screenBounds.origin.x, screenBounds.size.height, screenBounds.size.width);
    }

    return screenBounds;
}

- (void)setupIphoneEmulationOnIpad
{
    [_window aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^{
        [self adjustWindowAndRootControllerLayoutForIphoneEmulation];
    } error:nil];

    _window.clipsToBounds = YES;
}

- (void)adjustWindowAndRootControllerLayoutForIphoneEmulation
{
    CGRect realScreenBounds = [self realScreenBoundsFixed];
    _window.bounds = [self screenBounds];
    _window.center = CGPointMake(realScreenBounds.size.width/2, realScreenBounds.size.height/2);
    _window.rootViewController.view.frame = [self screenBounds];
    _window.rootViewController.view.clipsToBounds = YES;
}

@end
