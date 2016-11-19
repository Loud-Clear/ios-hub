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

@class DTNavigatorContext;
@class DTNavigatorRoute;


@interface DTNavigator : NSObject

@property (nonatomic, strong) NSArray<DTNavigatorRoute *> *routes;

- (void)navigateToURL:(NSURL *)url fromController:(UIViewController *)controller context:(DTNavigatorContext *)context;

- (BOOL)canNavigateToURL:(NSURL *)url fromController:(UIViewController *)controller;

@end
