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

#import "DTNavigatorRoute.h"
#import "DTNavigatorContext.h"


@implementation DTNavigatorRoute
{

    UIViewController *(^_block)(id viewController, id context);
}

+ (instancetype)forwardFrom:(NSString *)startUrl to:(NSString *)endUrl
{
    DTNavigatorRoute *route = [DTNavigatorRoute new];
    route.direction = DTNavigatorRouteDirectionForward;
    route.startURL = [NSURL URLWithString:startUrl];
    route.endURL = [NSURL URLWithString:endUrl];
    return route;
}

- (instancetype)initWithTransitionBlock:(UIViewController *(^)(UIViewController *viewController, DTNavigatorContext *context))block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (UIViewController *)performTransitionFromViewController:(UIViewController *)viewController context:(id)context
{
    UIViewController *controller = viewController;
    if (_block) {
        controller = _block(viewController, context);
    }
    return controller;
}

- (void)setTransition:(UIViewController *(^)(id viewController, DTNavigatorContext *context))block
{
    _block = block;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    if (self.direction == DTNavigatorRouteDirectionForward) {
        [description appendFormat:@"%@ -> %@", self.startURL, self.endURL];
    } else {
        [description appendFormat:@"%@ <- %@", self.endURL, self.startURL];
    }
    [description appendString:@">"];
    return description;
}


@end
