//
//  CCModuleURLParserTests.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright (c) 2016 FanHub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCModuleURLParser.h"

@interface CCModuleURLParserTests : XCTestCase

@end

@implementation CCModuleURLParserTests

- (void)setUp
{
    [super setUp];
    
    [CCModuleURLParser setWebBrowserControllerURL:[NSURL URLWithString:@"app:///WebBrowser.storyboard"]];
    [CCModuleURLParser setViewControllerPrefix:@"CC"];
    [CCModuleURLParser setViewControllerSuffix:@"ViewController"];
}

- (void)test_with_incorrect_scheme
{
    NSURL *url = [NSURL URLWithString:@"ftp://123123"];
    NSError *error = nil;
    [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CCModuleURLParserErrorCodeBadScheme);

    NSURL *url2 = [NSURL URLWithString:@"file:///123123"];
    [CCModuleURLParser parseURL:url2 error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CCModuleURLParserErrorCodeBadScheme);
}

- (void)test_web_scheme
{
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(result.storyboardName, @"WebBrowser");
    XCTAssertEqualObjects(result.parameters[@"url"], @"http://google.com");
}

- (void)test_in_app_storyboard
{
    NSURL *url = [NSURL URLWithString:@"app:///Entry/ResetPassword"];

    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(result.controllerName, @"ResetPassword");
    XCTAssertEqualObjects(result.storyboardName, @"Entry");
}

- (void)test_in_app_storyboard_implicit
{
    NSURL *url = [NSURL URLWithString:@"app:///Entry"];

    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertNil(result.controllerName);
    XCTAssertEqualObjects(result.storyboardName, @"Entry");
}

- (void)test_in_app_storyboard_explicit
{
    NSURL *url = [NSURL URLWithString:@"app:///Entry.storyboard"];

    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertNil(result.controllerName);
    XCTAssertEqualObjects(result.storyboardName, @"Entry");
}

- (void)test_in_app_controller_explicit
{
    NSURL *url = [NSURL URLWithString:@"app:///Entry.class"];

    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(result.controllerName, @"Entry");
    XCTAssertNil(result.storyboardName);
}


- (void)test_in_app_storyboard_with_params
{
    NSURL *url = [NSURL URLWithString:@"app:///Entry/ResetPassword?param1=hello%20world&param2=312"];

    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(result.controllerName, @"ResetPassword");
    XCTAssertEqualObjects(result.storyboardName, @"Entry");
    NSDictionary *params = @{
            @"param1" : @"hello world",
            @"param2" : @"312",
    };
    XCTAssertEqualObjects(result.parameters, params);
}

- (void)test_in_app_storyboard_with_incorrect_app_scheme
{
    NSURL *url = [NSURL URLWithString:@"app://Entry/ResetPassword?param1=asdf"];

    NSError *error = nil;
    [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CCModuleURLParserErrorCodeBadScheme);
}

- (void)test_controller_with_sub_controller_error
{
    NSURL *url = [NSURL URLWithString:@"app:///Controller.class/SubController"];
    NSError *error = nil;
    [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNotNil(error);
}

- (void)test_module_name_parsing
{
    NSURL *url = [NSURL URLWithString:@"app:///Welcome.module"];
    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(result.definitionKey, @"viewWelcomeModule");
    XCTAssertNil(result.storyboardName);
}

- (void)test_module_name_parsing_from_controller_name
{
    NSString *moduleName = [CCModuleURLParser moduleNameFromViewControllerClassName:@"CCSomeModuleViewController"];
    XCTAssertEqualObjects(moduleName, @"SomeModule");
}

- (void)test_controller_name_parsing_from_module_name
{
    NSString *controllerName = [CCModuleURLParser viewControllerClassNameFromModuleName:@"SomeModule"];
    XCTAssertEqualObjects(controllerName, @"CCSomeModuleViewController");
}

@end
