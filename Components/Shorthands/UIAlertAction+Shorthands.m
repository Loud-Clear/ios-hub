////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Accelerate/Accelerate.h>
#import "UIAlertAction+Shorthands.h"


@implementation UIAlertAction (Shorthands)

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style
{
    return [self actionWithTitle:title style:style handler:nil];
}

+ (instancetype)defaultActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    return [self actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}

+ (instancetype)defaultActionWithTitle:(NSString *)title
{
    return [self defaultActionWithTitle:title handler:nil];
}

+ (instancetype)okAction
{
    return [self defaultActionWithTitle:@"OK"];
}

+ (instancetype)cancelActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    return [self actionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}

+ (instancetype)cancelActionWithTitle:(NSString *)title
{
    return [self cancelActionWithTitle:title handler:nil];
}

+ (instancetype)cancelActionWithHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    return [self cancelActionWithTitle:@"Cancel" handler:handler];
}

+ (instancetype)cancelAction
{
    return [self cancelActionWithHandler:nil];
}

+ (instancetype)desctructiveActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    return [self actionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

+ (instancetype)desctructiveActionWithTitle:(NSString *)title
{
    return [self desctructiveActionWithTitle:title handler:nil];
}

@end
