
////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 03/06/2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CCEnvironment.h"
#import "CCMacroses.h"

@interface TestEnvironment : CCEnvironment

@property (nonatomic) NSString *baseApiUrl;
@property (nonatomic) NSString *title;

@end

@implementation TestEnvironment

+ (NSArray<NSString *> *)environmentFilenames
{
    return @[ @"Config.production.plist", @"Config.staging.plist" ];
}

@end


@interface CCEnvironmentTests : XCTestCase @end

@implementation CCEnvironmentTests

//-------------------------------------------------------------------------------------------
#pragma mark - Setup
//-------------------------------------------------------------------------------------------

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Tests
//-------------------------------------------------------------------------------------------

- (void)test_loading
{
    TestEnvironment *env = [TestEnvironment new];

    XCTAssertEqualObjects(env.baseApiUrl, @"http://api.com");

//    id observerMock = OCMClassMock([ObserverObject class]);
//    ObjectToObserve *objectToObserve = [ObjectToObserve new];
//
//    CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:objectToObserve observer:observerMock];
//
//    objectToObserve.value = @"123";
//
//    __block BOOL fired = NO;
//    [observer observeKeys:@[@"value"] withBlock:^{
//        fired = YES;
//    }];
//
//    objectToObserve.value = @"321";
//
//    XCTAssertTrue(fired);
}

@end
