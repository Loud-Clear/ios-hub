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

#import "CCModuleURLParser.h"

@interface NSString (ExtensionsChecks)

- (BOOL)hasExtensions:(NSArray *)extensions;

@end

@implementation NSString (ExtensionsChecks)

- (BOOL)hasExtensions:(NSArray *)extensions
{
    for (NSString *extension in extensions) {
        if ([[self pathExtension] isEqualToString:extension]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation CCModuleURLParserResult
@end

@implementation CCModuleURLParser

+ (CCModuleURLParserResult *)parseURL:(NSURL *)url error:(NSError **)error
{
    if ([self isInAppURL:url]) {
        return [self parseInAppURL:url error:error];
    } else if ([self isWebURL:url]) {
        CCModuleURLParserResult *result = [CCModuleURLParserResult new];
        result.storyboardName = @"WebBrowser";
        result.parameters = @{
                @"url": [url absoluteString]
        };
        return result;
    } else {
        if (error) {
            *error = [NSError errorWithDomain:ССModuleURLParserErrorDomain code:ССModuleURLParserErrorCodeBadScheme
                                     userInfo:@{
                                             NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Can't parse URL with protocol %@",
                                                                                                    [url scheme]]
                                     }];
        }
        return nil;
    }
}

+ (NSString *)moduleNameFromViewControllerClassName:(NSString *)className
{
    NSString *prefix = @"CC";
    NSString *suffix = @"ViewController";
    if ([className hasPrefix:prefix] && [className hasSuffix:suffix]) {
        NSRange prefixRange = NSMakeRange(0, [prefix length]);
        className = [className stringByReplacingCharactersInRange:prefixRange withString:@""];

        NSRange suffixRange = NSMakeRange([className length] - [suffix length], [suffix length]);
        return [className stringByReplacingCharactersInRange:suffixRange withString:@""];
    }
    return nil;
}

+ (NSString *)viewControllerClassNameFromModuleName:(NSString *)moduleName
{
    return [NSString stringWithFormat:@"CC%@ViewController", moduleName];
}


+ (CCModuleURLParserResult *)parseInAppURL:(NSURL *)url error:(NSError **)error
{
    CCModuleURLParserResult *result = [CCModuleURLParserResult new];

    NSArray<NSString *> *components = [url pathComponents];
    
    if ([[components firstObject] isEqualToString:@"/"]) {
        components = [components subarrayWithRange:NSMakeRange(1, [components count] - 1)];
    }

    if ([components count] > 0) {
        NSString *firstElement = [components firstObject];
        if ([firstElement hasExtensions:@[@"storyboard", @""]]) {
            result.storyboardName = [firstElement stringByDeletingPathExtension];
        } else if ([firstElement hasExtensions:@[@"class"]]) {
            result.controllerName = [firstElement stringByDeletingPathExtension];
        } else if ([firstElement hasExtensions:@[@"module"]]) {
            NSString *moduleName = [firstElement stringByDeletingPathExtension];
            result.definitionKey = [NSString stringWithFormat:@"view%@Module", moduleName];
        }
    } else {
        if (error) {
            *error = [NSError errorWithDomain:ССModuleURLParserErrorDomain code:ССModuleURLParserErrorCodeBadUrl
                                    userInfo:@{
                                            NSLocalizedDescriptionKey : @"Can't find components in URL"
                                    }];
        }
    }
    if ([components count] > 1) {
        if (result.storyboardName.length > 0) {
            result.controllerName = [components[1] stringByDeletingPathExtension];
        } else if (error) {
            NSString *errorText = [NSString stringWithFormat:@"Can't find storyboard for controller %@", components[1]];
            *error = [NSError errorWithDomain:ССModuleURLParserErrorDomain code:ССModuleURLParserErrorCodeBadUrl
                                     userInfo:@{
                                             NSLocalizedDescriptionKey : errorText
                                     }];
        }
    }
    result.parameters = [self parseParametersInURL:url];

    return result;
}

+ (NSDictionary *)parseParametersInURL:(NSURL *)url
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSString *query = [url query];
    for (NSString *keyValue in [query componentsSeparatedByString:@"&"]) {
        NSArray *components = [keyValue componentsSeparatedByString:@"="];
        if ([components count] == 2) {
            NSString *key = [components[0] stringByRemovingPercentEncoding];
            NSString *value = [components[1] stringByRemovingPercentEncoding];
            result[key] = value;
        }
    }
    
    return result;
}

+ (BOOL)isInAppURL:(NSURL *)url
{
    return [[url absoluteString] hasPrefix:@"app:///"];
}

+ (BOOL)isWebURL:(NSURL *)url
{
    return [[url scheme] hasPrefix:@"http"];
}

@end
