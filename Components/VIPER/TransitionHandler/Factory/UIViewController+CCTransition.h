////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCTransitionHandler.h"

@protocol CCModulePromise;

@interface UIViewController (CCTransition)

- (id<CCModulePromise>)openViewController:(UIViewController *)controller;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transitionBlock:(CCTransitionBlock)block;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller segueClass:(Class)segueClass;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transition:(CCTransitionStyle)style;

@end
