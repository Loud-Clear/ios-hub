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

@class CCNavigatorContext;
@class CCNavigatorRoute;


@interface CCNavigator : NSObject

@property (nonatomic, strong) NSArray<CCNavigatorRoute *> *routes;

- (void)navigateToURL:(NSURL *)url fromController:(UIViewController *)controller context:(CCNavigatorContext *)context;

- (BOOL)canNavigateToURL:(NSURL *)url fromController:(UIViewController *)controller;

@end
