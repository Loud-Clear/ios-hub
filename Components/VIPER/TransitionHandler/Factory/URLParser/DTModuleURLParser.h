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


static NSString *DTModuleURLParserErrorDomain = @"DTModuleURLParserErrorDomain";

typedef NS_ENUM(NSInteger, DTModuleURLParserErrorCode) {
    DTModuleURLParserErrorCodeUnknown = 0,
    DTModuleURLParserErrorCodeBadScheme,
    DTModuleURLParserErrorCodeBadUrl
};


@interface DTModuleURLParserResult : NSObject

@property (nonatomic, strong) NSString *storyboardName;
@property (nonatomic, strong) NSString *controllerName;
@property (nonatomic, strong) NSString *definitionKey;

@property (nonatomic, strong) NSDictionary *parameters;

@end

@interface DTModuleURLParser : NSObject

+ (DTModuleURLParserResult *)parseURL:(NSURL *)url error:(NSError **)error;

+ (NSString *)moduleNameFromViewControllerClassName:(NSString *)className;

+ (NSString *)viewControllerClassNameFromModuleName:(NSString *)moduleName;

+ (NSDictionary *)parseParametersInURL:(NSURL *)url;

@end
