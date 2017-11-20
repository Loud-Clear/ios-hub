////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 6.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


@interface UIViewController (Shorthands)

/// Same as [presentViewController:controller animated:animated completion:nil].
- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated;

/// Same as [presentViewController:controller animated:YES completion:nil].
- (void)presentViewController:(UIViewController *)controller;

/// Same as [dismissViewControllerAnimated:animated completion:nil].
- (void)dismissViewControllerAnimated:(BOOL)animated;

/// Same as [dismissViewControllerAnimated:YES completion:nil].
- (void)dismissViewController;

- (UIButton *)addButtonWithAction:(SEL)action;

- (UILabel *)addLabelWithFont:(UIFont *)font color:(UIColor *)color;

@end
