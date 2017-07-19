//
//  CCMacrosesTest.m
//  iOS Hub
//
//  Created by Ivan Zezyulya on 30/06/2017.
//  Copyright (c) 2017 Loud & Clear. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "CCMacroses.h"

@interface CCMacrosesTest : XCTestCase

@end

@implementation CCMacrosesTest {
    UIDevice *_currentDeviceMock;
}

- (void)setUp
{
    [super setUp];
    
    _currentDeviceMock = OCMPartialMock([UIDevice currentDevice]);
}

- (void)tearDown
{
    [super tearDown];

    [(id)_currentDeviceMock stopMocking];
}

- (void)testVersionMacros
{
    OCMStub([_currentDeviceMock systemVersion]).andReturn(@"9.1.4");

    XCTAssertTrue(CCIOSVersionLessThan(10));
    XCTAssertTrue(CCIOSVersionLessThanOrEqualTo(10));
    XCTAssertTrue(CCIOSVersionGreaterThan(6));
    XCTAssertTrue(CCIOSVersionGreaterThanOrEqualTo(7));

    XCTAssertTrue(CCIOSVersionGreaterThanOrEqualTo(9.1));
    XCTAssertTrue(CCIOSVersionGreaterThanOrEqualTo(9.1.4));
    XCTAssertFalse(CCIOSVersionLessThanOrEqualTo(9));
    XCTAssertFalse(CCIOSVersionLessThanOrEqualTo(9.1));
    XCTAssertFalse(CCIOSVersionLessThanOrEqualTo(9.1.0));
}

@end
