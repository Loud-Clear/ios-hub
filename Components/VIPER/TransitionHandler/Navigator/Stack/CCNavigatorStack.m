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

#import "CCNavigatorStack.h"
#import "CCMapCollections.h"
#import "UIViewController+URL.h"
#import "CCModuleURLParser.h"


NSString *StringFromUrlWithoutQuery(NSURL *url)
{
    return [url query] ?[[url absoluteString] stringByReplacingOccurrencesOfString:[url query]
                                                                        withString:@""] : [url absoluteString];
}

BOOL CCSameUrls(NSURL *urlA, NSURL *urlB)
{
    // If both has query - check that all parameters matches
    if ([urlA query] && [urlB query]) {
        NSDictionary *paramsA = [CCModuleURLParser parseParametersInURL:urlA];
        NSDictionary *paramsB = [CCModuleURLParser parseParametersInURL:urlB];
        return [StringFromUrlWithoutQuery(urlA) isEqualToString:StringFromUrlWithoutQuery(urlB)] && [paramsA isEqualToDictionary:paramsB];
    } else {
        //Check string without query
        return [StringFromUrlWithoutQuery(urlA) isEqualToString:StringFromUrlWithoutQuery(urlB)];
    }
}

@implementation CCNavigatorStack
{
    NSMutableOrderedSet *_viewControllers;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewControllers = [NSMutableOrderedSet new];
    }
    return self;
}


- (void)addViewController:(UIViewController *)viewController
{
    [_viewControllers addObject:viewController];
}

- (NSArray<NSURL *> *)allUrls
{
    return (NSArray<NSURL *> *)[[self allViewControllers] arrayUsingMap:^id(UIViewController *object) {
        return [object cc_url];
    }];
}

- (NSArray<UIViewController *> *)allViewControllers
{
    return [_viewControllers array];
}

- (UIViewController *)controllerForURL:(NSURL *)url
{
    return [[[self allViewControllers] arrayUsingMap:^id(UIViewController *object) {
        return CCSameUrls([object cc_url], url)?object : nil;
    }] firstObject];
}

@end
