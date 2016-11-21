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

#import <Foundation/Foundation.h>


static NSString *ССModuleURLParserErrorDomain = @"ССModuleURLParserErrorDomain";

typedef NS_ENUM(NSInteger, ССModuleURLParserErrorCode) {
    ССModuleURLParserErrorCodeUnknown = 0,
    ССModuleURLParserErrorCodeBadScheme,
    ССModuleURLParserErrorCodeBadUrl
};


@interface CCModuleURLParserResult : NSObject

@property (nonatomic, strong) NSString *storyboardName;
@property (nonatomic, strong) NSString *controllerName;
@property (nonatomic, strong) NSString *definitionKey;

@property (nonatomic, strong) NSDictionary *parameters;

@end

@interface CCModuleURLParser : NSObject

+ (CCModuleURLParserResult *)parseURL:(NSURL *)url error:(NSError **)error;

+ (NSString *)moduleNameFromViewControllerClassName:(NSString *)className;

+ (NSString *)viewControllerClassNameFromModuleName:(NSString *)moduleName;

+ (NSDictionary *)parseParametersInURL:(NSURL *)url;

@end
