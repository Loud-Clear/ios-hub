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

#import "UIAlertController+Shorthands.h"


@implementation UIAlertController (Shorthands)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithTitle:(NSString *)title
{
    return [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)alertWithMessage:(NSString *)message
{
    return [self alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
{
    return [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheetWithMessage:(NSString *)message
{
    return [self alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)actionSheet
{
    return [self alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
}

@end
