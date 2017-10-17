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

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Shorthands)

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertWithTitle:(nullable NSString *)title;
+ (instancetype)alertWithMessage:(nullable NSString *)message;

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)actionSheetWithMessage:(nullable NSString *)message;
+ (instancetype)actionSheet;

@end

NS_ASSUME_NONNULL_END
