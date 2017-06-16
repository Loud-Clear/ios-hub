
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
#import <KVOController/NSObject+FBKVOController.h>

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
    [TestEnvironment setCurrentEnvironment:[[TestEnvironment availableEnvironments] firstObject]];
    [TestEnvironment resetAll];
}

- (void)tearDown
{
    [super tearDown];
    [TestEnvironment resetAll];
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

- (void)test_switchEnv
{
    NSArray<TestEnvironment *> *envs = (id)[TestEnvironment availableEnvironments];
    TestEnvironment *env = [TestEnvironment currentEnvironment];

    [TestEnvironment setCurrentEnvironment:envs[1]];

    XCTAssertEqualObjects(env.title, @"UAT");

    [TestEnvironment setCurrentEnvironment:envs[0]];

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

    TestEnvironment *another = [[TestEnvironment availableEnvironments] firstObject];
    another.title = @"New Title 2";

    XCTAssertEqualObjects(env.title, @"New Title 2");


    env.title = @"Prod";
}

- (void)test_observingWhenSwitchingEnvs
{
    NSArray<TestEnvironment *> *envs = (id)[TestEnvironment availableEnvironments];
    TestEnvironment *env = [TestEnvironment currentEnvironment];

    __block BOOL observed = NO;

    [self.KVOController observe:env keyPath:@"title" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
        observed = YES;
    }];

    [TestEnvironment setCurrentEnvironment:envs[1]];

    XCTAssertTrue(observed);
}

- (void)test_reset
{
    NSString *initialTitle = nil;
    {
        TestEnvironment *env = [TestEnvironment currentEnvironment];

        initialTitle = env.title;
        env.title = @"Foo";
    }

    [TestEnvironment resetAll];

    TestEnvironment *env = [TestEnvironment currentEnvironment];

    XCTAssertEqualObjects(env.title, initialTitle);
}

- (void)test_duplicating
{
    TestEnvironment *current = [TestEnvironment currentEnvironment];


    XCTAssertEqual([[TestEnvironment availableEnvironments] count], 2);

    TestEnvironment *copy = [TestEnvironment duplicate:current];

    XCTAssertEqual([[TestEnvironment availableEnvironments] count], 3);

    XCTAssertTrue([copy.title isEqualToString:current.title]);

    copy.title = @"123";

    XCTAssertFalse([copy.title isEqualToString:current.title]);

    [copy delete];

    XCTAssertEqual([[TestEnvironment availableEnvironments] count], 2);
}


@end
