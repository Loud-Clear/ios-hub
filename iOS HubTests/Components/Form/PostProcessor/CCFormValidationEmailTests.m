//
//  CCFormValidationEmailTests.m
//  iOS Hub
//
//  Created by Aleksey Garbarev on 10/12/2016.
//  Copyright (c) 2016 Loud & Clear. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCFormValidationEmail.h"

@interface CCFormValidationEmailTests : XCTestCase

@end

@implementation CCFormValidationEmailTests {
    CCFormValidationEmail *_validator;
}

- (void)setUp
{

    _validator = [CCFormValidationEmail withField:@"email" error:@"Please enter valid email"];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)test_valid_email
{
    XCTAssertTrue([_validator validateData:@{ @"email": @"alex@gmail.com" }  error:nil]);
    XCTAssertTrue([_validator validateData:@{ @"email": @"alex@gmail.ru" }  error:nil]);
    XCTAssertTrue([_validator validateData:@{ @"email": @"ale_x@gmail.ru" }  error:nil]);
    XCTAssertTrue([_validator validateData:@{ @"email": @"ale_x@gm.a.il.ru" }  error:nil]);
}

- (void)test_invalid_email
{
    XCTAssertFalse([_validator validateData:@{ @"email": @"alex@gmail.c" }  error:nil]);
    XCTAssertFalse([_validator validateData:@{ @"email": @"alexgmail.c" }  error:nil]);
}

@end
