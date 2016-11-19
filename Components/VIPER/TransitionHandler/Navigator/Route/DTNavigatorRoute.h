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

typedef NS_ENUM(NSInteger, DTNavigatorRouteDirection) {
    DTNavigatorRouteDirectionForward,
    DTNavigatorRouteDirectionBack
};

@interface DTNavigatorRoute : NSObject

@property (nonatomic, strong) NSURL *startURL;
@property (nonatomic, strong) NSURL *endURL;
@property (nonatomic) DTNavigatorRouteDirection direction;

+ (instancetype)forwardFrom:(NSString *)startUrl to:(NSString *)endUrl;

- (instancetype)initWithTransitionBlock:(UIViewController *(^)(UIViewController *viewController, DTNavigatorContext *context))block;

- (UIViewController *)performTransitionFromViewController:(UIViewController *)viewController context:(DTNavigatorContext *)context;

- (void)setTransition:(UIViewController *(^)(id viewController, DTNavigatorContext *context))block;

@end
