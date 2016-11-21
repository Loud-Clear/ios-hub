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

#import "CCNavigatorRoute.h"
#import "CCNavigatorContext.h"


@implementation CCNavigatorRoute
{

    UIViewController *(^_block)(id viewController, id context);
}

+ (instancetype)forwardFrom:(NSString *)startUrl to:(NSString *)endUrl
{
    CCNavigatorRoute *route = [CCNavigatorRoute new];
    route.direction = ССNavigatorRouteDirectionForward;
    route.startURL = [NSURL URLWithString:startUrl];
    route.endURL = [NSURL URLWithString:endUrl];
    return route;
}

- (instancetype)initWithTransitionBlock:(UIViewController *(^)(UIViewController *viewController, CCNavigatorContext *context))block
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

- (void)setTransition:(UIViewController *(^)(id viewController, CCNavigatorContext *context))block
{
    _block = block;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    if (self.direction == ССNavigatorRouteDirectionForward) {
        [description appendFormat:@"%@ -> %@", self.startURL, self.endURL];
    } else {
        [description appendFormat:@"%@ <- %@", self.endURL, self.startURL];
    }
    [description appendString:@">"];
    return description;
}


@end
