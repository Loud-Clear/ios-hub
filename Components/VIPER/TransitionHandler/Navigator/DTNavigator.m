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

#import "DTNavigator.h"
#import "CCMapCollections.h"
#import "UIViewController+URL.h"
#import "DTNavigatorRoute.h"
#import "DTTransitionHandler.h"
#import "DTNavigatorContext.h"
#import "DTModule.h"
#import "DTNavigatorContext.h"
#import "DTNavigatorStack.h"
#import "DTMacroses.h"

DTNavigatorStack *StackForController(UIViewController *viewController)
{
    DTNavigatorStack *stack = [DTNavigatorStack new];

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

@implementation DTNavigator

- (BOOL)canNavigateToURL:(NSURL *)url fromController:(UIViewController *)controller
{
    return [self pathToURL:url fromViewController:controller] != nil;
}

- (void)navigateToURL:(NSURL *)url fromController:(UIViewController *)controller context:(DTNavigatorContext *)context
{
    NSArray<DTNavigatorRoute *> *path = [self pathToURL:url fromViewController:controller];

    NSURL *rootUrl = [[path firstObject] startURL];

    UIViewController *rootController = [self controllerAfterNavigationBackToURL:rootUrl fromViewController:controller context:context];

    [self performPath:path fromViewController:rootController context:context];
}

//TODO: Implement Dijkstra's algorithm to find shortest route
- (NSArray<DTNavigatorRoute *> *)pathToURL:(NSURL *)url fromViewController:(UIViewController *)controller
{
    NSMutableArray<DTNavigatorRoute *> *path = [NSMutableArray new];
    BOOL didFoundRoute = NO;

    DTNavigatorStack *stack = StackForController(controller);

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
    if (DTSameUrls(targetUrl, sourceURL)) {
        return YES;
    }

    NSArray<DTNavigatorRoute *> *routes = [self routesToUrl:targetUrl withDirection:DTNavigatorRouteDirectionForward];

    for (DTNavigatorRoute *route in routes) {
        if (DTSameUrls(route.startURL, sourceURL)) {
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

- (NSArray<DTNavigatorRoute *> *)routesToUrl:(NSURL *)targetUrl withDirection:(DTNavigatorRouteDirection)direction
{
    NSMutableArray *routesToTarget = [NSMutableArray new];

    for (DTNavigatorRoute *route in self.routes) {
        if (route.direction == direction && DTSameUrls(route.endURL, targetUrl)) {
            [routesToTarget addObject:route];
        }
    }

    return routesToTarget;
}

- (UIViewController *)controllerAfterNavigationBackToURL:(NSURL *)url fromViewController:(UIViewController *)controller context:(DTNavigatorContext *)context
{
    NSMutableArray<DTNavigatorRoute *> *backPath = [NSMutableArray new];

    NSURL *targetUrl = url;
    DTNavigatorRoute *foundRoute = nil;
    do {
        for (DTNavigatorRoute *route in self.routes) {
            if (route.direction == DTNavigatorRouteDirectionBack && DTSameUrls(route.endURL, targetUrl)) {
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
    while (!DTSameUrls(foundRoute.startURL, [controller dt_url]));

    UIViewController *result = nil;
    if (backPath) {
        result = [self performPath:backPath fromViewController:controller context:context];
    } else {
        DTNavigatorStack *stack = StackForController(controller);
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

- (UIViewController *)performPath:(NSArray *)path fromViewController:(UIViewController *)viewController context:(DTNavigatorContext *)context
{
    DDLogDebug(@"Path: %@", path);
    UIViewController *input = viewController;

    for (DTNavigatorRoute *route in path) {
        input = [route performTransitionFromViewController:input context:context];
    }

    return input;
}


@end
