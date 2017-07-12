
#import "UIApplication+TopmostViewController.h"

static UIViewController *TopVisibleViewControllerForController(UIViewController *controller)
{
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        return TopVisibleViewControllerForController(tabBarController.selectedViewController);
    }
    else if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)controller;
        return TopVisibleViewControllerForController(navigationController.visibleViewController);
    }
    else if (controller.presentedViewController) {
        return TopVisibleViewControllerForController(controller.presentedViewController);
    }
    else if (controller.childViewControllers.count > 0) {
        return TopVisibleViewControllerForController(controller.childViewControllers.lastObject);
    }

    return controller;
}

@implementation UIApplication (TopmostViewController)

- (UIViewController *)topmostViewController
{
    return TopVisibleViewControllerForController(self.keyWindow.rootViewController);
}

@end


@implementation UIViewController (TopmostViewController)

- (UIViewController *)topmostViewController
{
    return TopVisibleViewControllerForController(self);
}

@end