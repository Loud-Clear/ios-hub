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

#import "CCNavigator.h"
#import "CCMapCollections.h"
#import "UIViewController+URL.h"
#import "CCNavigatorRoute.h"
#import "CCTransitionHandler.h"
#import "CCNavigatorContext.h"
#import "CCModule.h"
#import "CCNavigatorContext.h"
#import "CCNavigatorStack.h"
#import "CCMacroses.h"

CCNavigatorStack *StackForController(UIViewController *viewController)
{
    CCNavigatorStack *stack = [CCNavigatorStack new];

    UIViewController *parent = viewController;
    while (parent) {

        if ([parent isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigation = (id)parent;

            [navigation.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController *obj, NSUInteger idx, BOOL *stop) {
                [stack addViewController:obj];
            }];
            [stack addViewController:parent];

        } else {
            [stack addViewController:parent];
        }
        parent = parent.parentViewController;
    }
    return stack;
}

@implementation CCNavigator

- (BOOL)canNavigateToURL:(NSURL *)url fromController:(UIViewController *)controller
{
    return [self pathToURL:url fromViewController:controller] != nil;
}

- (void)navigateToURL:(NSURL *)url fromController:(UIViewController *)controller context:(CCNavigatorContext *)context
{
    NSArray<CCNavigatorRoute *> *path = [self pathToURL:url fromViewController:controller];

    NSURL *rootUrl = [[path firstObject] startURL];

    UIViewController *rootController = [self controllerAfterNavigationBackToURL:rootUrl fromViewController:controller context:context];

    [self performPath:path fromViewController:rootController context:context];
}

//TODO: Implement Dijkstra's algorithm to find shortest route
- (NSArray<CCNavigatorRoute *> *)pathToURL:(NSURL *)url fromViewController:(UIViewController *)controller
{
    NSMutableArray<CCNavigatorRoute *> *path = [NSMutableArray new];
    BOOL didFoundRoute = NO;

    CCNavigatorStack *stack = StackForController(controller);

    for (NSURL *sourceUrl in [stack allUrls]) {
        if ([self findPathToURL:url fromURL:sourceUrl path:path]) {
            didFoundRoute = YES;
            break;
        }
    }

    if (didFoundRoute) {
        return path;
    } else {
        return nil;
    }
}

- (BOOL)findPathToURL:(NSURL *)targetUrl fromURL:(NSURL *)sourceURL path:(NSMutableArray *)path
{
    if (CCSameUrls(targetUrl, sourceURL)) {
        return YES;
    }

    NSArray<CCNavigatorRoute *> *routes = [self routesToUrl:targetUrl withDirection:CCNavigatorRouteDirectionForward];

    for (CCNavigatorRoute *route in routes) {
        if (CCSameUrls(route.startURL, sourceURL)) {
            [path insertObject:route atIndex:0];
            return YES;
        } else {
            NSMutableArray *result = [NSMutableArray new];
            if ([self findPathToURL:route.startURL fromURL:sourceURL path:result]) {
                [path insertObject:route atIndex:0];
                [path insertObjects:result atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [result count])]];
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray<CCNavigatorRoute *> *)routesToUrl:(NSURL *)targetUrl withDirection:(CCNavigatorRouteDirection)direction
{
    NSMutableArray *routesToTarget = [NSMutableArray new];

    for (CCNavigatorRoute *route in self.routes) {
        if (route.direction == direction && CCSameUrls(route.endURL, targetUrl)) {
            [routesToTarget addObject:route];
        }
    }

    return routesToTarget;
}

- (UIViewController *)controllerAfterNavigationBackToURL:(NSURL *)url fromViewController:(UIViewController *)controller context:(CCNavigatorContext *)context
{
    NSMutableArray<CCNavigatorRoute *> *backPath = [NSMutableArray new];

    NSURL *targetUrl = url;
    CCNavigatorRoute *foundRoute = nil;
    do {
        for (CCNavigatorRoute *route in self.routes) {
            if (route.direction == CCNavigatorRouteDirectionBack && CCSameUrls(route.endURL, targetUrl)) {
                foundRoute = route;
                [backPath insertObject:route atIndex:0];
                break;
            }
        }
        if (!foundRoute) {
            backPath = nil;
            break;
        }
        targetUrl = foundRoute.startURL;
    }
    while (!CCSameUrls(foundRoute.startURL, [controller cc_url]));

    UIViewController *result = nil;
    if (backPath) {
        result = [self performPath:backPath fromViewController:controller context:context];
    } else {
        CCNavigatorStack *stack = StackForController(controller);
        result = [stack controllerForURL:url];
        if (result.navigationController == controller.navigationController) {
			UIViewController *toViewController = result;
			while(toViewController && ![result.navigationController.viewControllers containsObject:toViewController])
			{
				toViewController = result.parentViewController;
			}
            if (!toViewController) {
                toViewController = result;
            }
            [result.navigationController popToViewController:toViewController animated:NO];
        }
    }

    return result;
}

- (UIViewController *)performPath:(NSArray *)path fromViewController:(UIViewController *)viewController context:(CCNavigatorContext *)context
{
    DDLogDebug(@"Path: %@", path);
    UIViewController *input = viewController;

    for (CCNavigatorRoute *route in path) {
        input = [route performTransitionFromViewController:input context:context];
    }

    return input;
}


@end
