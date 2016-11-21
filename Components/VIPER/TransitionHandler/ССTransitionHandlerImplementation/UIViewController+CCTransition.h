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

@interface UIViewController (ССTransition)

- (id<CCModulePromise>)openViewController:(UIViewController *)controller;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transitionBlock:(ССTransitionBlock)block;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller segueClass:(Class)segueClass;

- (id<CCModulePromise>)openViewController:(UIViewController *)controller transition:(ССTransitionStyle)style;

@end
