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
#import "UIViewController+DTTransition.h"
#import "DTTransitionPromise.h"
#import "DTDisplayManager.h"
#import "DTMacroses.h"

static BOOL kAnimationsEnabled = YES;

@implementation DTTransitionHandler

+ (void)performWithoutAnimation:(void(^)())transitions
{
    BOOL wasEnabled = kAnimationsEnabled;
    kAnimationsEnabled = NO;
    SafetyCall(transitions)
    kAnimationsEnabled = wasEnabled;
}

@end


@implementation UIViewController (DTTransition)


- (id<DTModulePromise>)openViewController:(UIViewController *)controller
{
    return [self openViewController:controller transition:DTTransitionStyleAutomatic];
}

- (id<DTModulePromise>)openViewController:(UIViewController *)controller transitionBlock:(DTTransitionBlock)block
{
    DTTransitionPromise *openModulePromise = [DTTransitionPromise new];

    UIViewController<DTTransitionHandler> *destination = (UIViewController<DTTransitionHandler> *)controller;

    openModulePromise.nextViewController = destination;
    openModulePromise.moduleInput = [destination moduleInput];

    [openModulePromise addPostLinkBlock:^(id input, UIViewController *next){
        SafetyCall(block, self, destination);
    }];

    return openModulePromise;
}

- (id<DTModulePromise>)openViewController:(UIViewController *)controller segueClass:(Class)segueClass
{
    return [self openViewController:controller transitionBlock:^(UIViewController *source, UIViewController *destination) {
        UIStoryboardSegue *segue = [(UIStoryboardSegue *)[segueClass alloc] initWithIdentifier:@"OpenModuleSegue"
                                                                                        source:source
                                                                                   destination:destination];
        [segue perform];
    }];
}

- (id<DTModulePromise>)openViewController:(UIViewController *)controller transition:(DTTransitionStyle)style
{
    DTTransitionBlock block = nil;

    TyphoonComponentFactory *sharedFactory = [TyphoonComponentFactory factoryForResolvingUI];
    DTDisplayManager *displayManager = [sharedFactory componentForType:[DTDisplayManager class]];

    switch (style) {
        case DTTransitionStyleModal: {
            block = ^(UIViewController *src, UIViewController *dst) {
                [src presentViewController:dst animated:YES completion:nil];
            };
            break;
        }
        case DTTransitionStylePushAsRoot:
        case DTTransitionStylePush: {
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

                if (style == DTTransitionStylePushAsRoot) {
                    [navigationController setViewControllers:@[dst] animated:kAnimationsEnabled];
                } else {
                    [navigationController pushViewController:dst animated:kAnimationsEnabled];
                }
            };
            break;
        }
        case DTTransitionStyleReplaceRoot: {
            block = ^(UIViewController *src, UIViewController *dst) {
                [displayManager replaceRootViewControllerWith:dst animation:DTDisplayManagerTransitionAnimationNone];
            };
            break;
        }
        case DTTransitionStyleAutomatic: {
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
