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

typedef NS_ENUM(NSInteger, CCNavigatorRouteDirection) {
    CCNavigatorRouteDirectionForward,
    CCNavigatorRouteDirectionBack
};

@interface CCNavigatorRoute : NSObject

@property (nonatomic, strong) NSURL *startURL;
@property (nonatomic, strong) NSURL *endURL;
@property (nonatomic) CCNavigatorRouteDirection direction;

+ (instancetype)forwardFrom:(NSString *)startUrl to:(NSString *)endUrl;

- (instancetype)initWithTransitionBlock:(UIViewController *(^)(UIViewController *viewController, CCNavigatorContext *context))block;

- (UIViewController *)performTransitionFromViewController:(UIViewController *)viewController context:(CCNavigatorContext *)context;

- (void)setTransition:(UIViewController *(^)(id viewController, CCNavigatorContext *context))block;

@end
