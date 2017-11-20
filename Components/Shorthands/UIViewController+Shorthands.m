////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 6.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIViewController+Shorthands.h"
#import "UIButton+Shorthands.h"
#import "UILabel+Shorthands.h"
#import "CCMacroses.h"


@implementation UIViewController (Shorthands)

- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated
{
    [self presentViewController:controller animated:animated completion:nil];
}

- (void)presentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismissViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)addButtonWithAction:(SEL)action
{
    let button = [UIButton withTarget:self action:action];
    [self.view addSubview:button];
    return button;
}

- (UILabel *)addLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    let label = [UILabel withFont:font color:color];
    return label;
}

@end
