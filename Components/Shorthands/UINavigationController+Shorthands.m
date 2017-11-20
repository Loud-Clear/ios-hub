////////////////////////////////////////////////////////////////////////////////
//
//  iOS Hub
//  Created by ivan at 17.10.2017.
//
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UINavigationController+Shorthands.h"


@implementation UINavigationController (Shorthands)

+ (instancetype)withRootController:(UIViewController *)rootController
{
    return [[self alloc] initWithRootViewController:rootController];
}

@end
