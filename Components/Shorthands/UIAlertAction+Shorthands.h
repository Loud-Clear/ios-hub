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

@interface UIAlertAction (Shorthands)

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style;

+ (instancetype)defaultActionWithTitle:(NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
+ (instancetype)defaultActionWithTitle:(NSString *)title;
+ (instancetype)okAction;

+ (instancetype)cancelActionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
+ (instancetype)cancelActionWithTitle:(nullable NSString *)title;
+ (instancetype)cancelAction;
+ (instancetype)cancelActionWithHandler:(void (^ __nullable)(UIAlertAction *action))handler;

+ (instancetype)desctructiveActionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction *action))handler;
+ (instancetype)desctructiveActionWithTitle:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
