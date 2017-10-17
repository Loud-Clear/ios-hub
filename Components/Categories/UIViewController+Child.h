//
//  UIViewController+Child.h
//
//  Created by Ivan Zezyulya on 26.03.14.
//

@interface UIViewController (Child)

/// Just sets childController as child of self.
- (void) cc_setChildController:(UIViewController *)childController;

/// Sets childController as child of self and adds its view to self.view.
- (void) cc_addChildController:(UIViewController *)childController;

/// Sets childController as child of self and adds its view to view.
- (void) cc_addChildController:(UIViewController *)childController toView:(UIView *)view;

/// Sets childController as child of self, adds its view to containerView and adjusts its frame to match containerView bounds.
- (void) cc_addChildController:(UIViewController *)childController toContainerView:(UIView *)containerView;

- (void) cc_removeChildController:(UIViewController *)childController;

@end
