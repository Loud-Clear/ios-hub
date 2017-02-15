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

#import <Typhoon/TyphoonComponentFactory.h>
#import "UIViewController+CCTransition.h"
#import "CCTransitionPromise.h"
#import "CCDisplayManager.h"
#import "CCMacroses.h"

static BOOL kAnimationsEnabled = YES;

@implementation CCTransitionHandler

+ (void)performWithoutAnimation:(void(^)())transitions
{
    BOOL wasEnabled = kAnimationsEnabled;
    kAnimationsEnabled = NO;
    SafetyCall(transitions)
    kAnimationsEnabled = wasEnabled;
}

@end


@implementation UIViewController (CCTransition)


- (id<CCModulePromise>)openViewController:(UIViewController *)controller
{
    return [self openViewController:controller transition:CCTransitionStyleAutomatic];
}

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transitionBlock:(CCTransitionBlock)block
{
    CCTransitionPromise *openModulePromise = [CCTransitionPromise new];

    UIViewController<CCTransitionHandler> *destination = (UIViewController<CCTransitionHandler> *)controller;

    openModulePromise.nextViewController = destination;
    openModulePromise.moduleInput = [destination moduleInput];

    [openModulePromise addPostLinkBlock:^(id input, UIViewController *next){
        SafetyCall(block, self, destination);
    }];

    return openModulePromise;
}

- (id<CCModulePromise>)openViewController:(UIViewController *)controller segueClass:(Class)segueClass
{
    return [self openViewController:controller transitionBlock:^(UIViewController *source, UIViewController *destination) {
        UIStoryboardSegue *segue = [(UIStoryboardSegue *)[segueClass alloc] initWithIdentifier:@"OpenModuleSegue"
                                                                                        source:source
                                                                                   destination:destination];
        [segue perform];
    }];
}

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transition:(CCTransitionStyle)style
{
    CCTransitionBlock block = nil;

    TyphoonComponentFactory *sharedFactory = [TyphoonComponentFactory factoryForResolvingUI];
    CCDisplayManager *displayManager = [sharedFactory componentForType:[CCDisplayManager class]];

    switch (style) {
        case CCTransitionStyleModal: {
            block = ^(UIViewController *src, UIViewController *dst) {
                [src presentViewController:dst animated:YES completion:nil];
            };
            break;
        }
        case CCTransitionStylePushAsRoot:
        case CCTransitionStylePush: {
            block = ^(UIViewController *src, UIViewController *dst) {
                UINavigationController *navigationController = nil;

                if ([dst isKindOfClass:[UINavigationController class]]) {
                    dst = [[(UINavigationController *)dst viewControllers] firstObject];
                }

                if ([src isKindOfClass:[UINavigationController class]]) {
                    navigationController = (UINavigationController *)src;
                } else if (src.navigationController) {
                    navigationController = src.navigationController;
                }
                NSAssert(navigationController, @"Can't find navigationController to push");

                if (style == CCTransitionStylePushAsRoot) {
                    [navigationController setViewControllers:@[dst] animated:kAnimationsEnabled];
                } else {
                    [navigationController pushViewController:dst animated:kAnimationsEnabled];
                }
            };
            break;
        }
        case CCTransitionStyleReplaceRoot: {
            block = ^(UIViewController *src, UIViewController *dst) {
                [displayManager replaceRootViewControllerWith:dst animation:CCDisplayManagerTransitionAnimationNone];
            };
            break;
        }
        case CCTransitionStyleAutomatic: {
            block = ^(UIViewController *src, UIViewController *dst) {
                BOOL canPush = (src.navigationController || [src isKindOfClass:[UINavigationController class]]) &&
                        ![dst isKindOfClass:[UINavigationController class]];
                if (canPush) {
                    if ([src isKindOfClass:[UINavigationController class]]) {
                        [(UINavigationController *)src pushViewController:dst animated:kAnimationsEnabled];
                    } else {
                        [src.navigationController pushViewController:dst animated:kAnimationsEnabled];
                    }
                } else {
                    [src presentViewController:dst animated:kAnimationsEnabled completion:nil];
                }
            };
            break;
        }
    }

    return [self openViewController:controller transitionBlock:block];
}

@end
