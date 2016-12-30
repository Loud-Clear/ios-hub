
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
    TestEnvironment *env = [TestEnvironment currentEnvironment];

    XCTAssertEqualObjects(env.baseApiUrl, @"http://api.com");
}

- (void)test_availableEnvs
{
    NSArray<TestEnvironment *> *envs = (id)[TestEnvironment availableEnvironments];

    XCTAssertEqual([envs count], 2);
    XCTAssertEqualObjects(envs[0].title, @"Prod");
    XCTAssertEqualObjects(envs[1].title, @"UAT");
}

- (void)test_useEnv
{
    NSArray<TestEnvironment *> *envs = (id)[TestEnvironment availableEnvironments];
    TestEnvironment *env = [TestEnvironment currentEnvironment];

    [env useEnvironment:envs[1]];

    XCTAssertEqualObjects(env.title, @"UAT");

    [env useEnvironment:envs[0]];

    XCTAssertEqualObjects(env.title, @"Prod");
}

- (void)test_save
{
    {
        TestEnvironment *env = [TestEnvironment currentEnvironment];
        env.title = @"New title";
    }

    TestEnvironment *env = [TestEnvironment currentEnvironment];
    XCTAssertEqualObjects(env.title, @"New title");

    env.title = @"Prod";
}

@end
