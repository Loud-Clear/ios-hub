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

#import "DTTransitionHandler.h"

@protocol DTModulePromise;

@interface UIViewController (DTTransition)

- (id<DTModulePromise>)openViewController:(UIViewController *)controller;

- (id<DTModulePromise>)openViewController:(UIViewController *)controller transitionBlock:(DTTransitionBlock)block;

- (id<DTModulePromise>)openViewController:(UIViewController *)controller segueClass:(Class)segueClass;

- (id<DTModulePromise>)openViewController:(UIViewController *)controller transition:(DTTransitionStyle)style;

@end
