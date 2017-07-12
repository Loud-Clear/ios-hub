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

#import <UIKit/UIKit.h>

BOOL CCSameUrls(NSURL *urlA, NSURL *urlB);

@interface CCNavigatorStack : NSObject

- (void)addViewController:(UIViewController *)viewController;

- (NSArray<NSURL *> *)allUrls;

- (NSArray<UIViewController *> *)allViewControllers;

- (UIViewController *)controllerForURL:(NSURL *)url;

@end
