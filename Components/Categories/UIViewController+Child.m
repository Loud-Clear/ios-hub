//
//  UIViewController+Child.m
//
//  Created by Ivan Zezyulya on 26.03.14.
//

#import "UIViewController+Child.h"


@implementation UIViewController (Child)

- (void)cc_setChildController:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [childController didMoveToParentViewController:self];
}

- (void)cc_addChildController:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)cc_addChildController:(UIViewController *)childController toView:(UIView *)view
{
    [self addChildViewController:childController];
    [view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)cc_addChildController:(UIViewController *)childController toContainerView:(UIView *)view
{
    [self addChildViewController:childController];
    childController.view.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)cc_removeChildController:(UIViewController *)childController
{
    [childController willMoveToParentViewController:nil];
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
}

@end
