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

#import "CCObjectObserver.h"
#import "CCMacroses.h"
#import "NSObject+Observe.h"

static NSInteger gObjectToObserveDeallocCount = 0;
static NSInteger gObserverDeallocCount = 0;

@interface Observer : NSObject

- (void)didChangeValue;

@end

@implementation Observer

- (void)didChangeValue
{
}

- (void)dealloc
{
    gObserverDeallocCount++;
}

@end

////

@interface ObjectToObserve : NSObject

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSNumber *number;

@end

@implementation ObjectToObserve

- (void)dealloc
{
    gObjectToObserveDeallocCount++;
}


@end


@interface CCObjectObserverTests : XCTestCase


@end

@implementation CCObjectObserverTests

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

- (void)test_basic_observation
{
    id observerMock = OCMClassMock([Observer class]);
    ObjectToObserve *objectToObserve = [ObjectToObserve new];

    CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:objectToObserve observer:observerMock];

    objectToObserve.value = @"123";

    __block BOOL fired = NO;
    [observer observeKeys:@[@"value"] withBlock:^{
        fired = YES;
    }];

    objectToObserve.value = @"321";

    XCTAssertTrue(fired);
}

//Test internals with mocks/stubs
- (void)test_multiple_changes_one_call
{
    ObjectToObserve *objectToObserve = [ObjectToObserve new];

    CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:objectToObserve observer:nil];


    XCTestExpectation *e = [self expectationWithDescription:@""];

    __block NSInteger callCount = 0;
    [observer observeKeys:@[@"value", @"number"] withBlock:^{
        callCount += 1;
    }];

    SafetyCallAfter(0.2, ^{
        [e fulfill];
    });

    objectToObserve.number = @2;
    objectToObserve.value = @"123";

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *_Nullable error) {

    }];

    XCTAssertEqual(callCount, 1);
}

- (void)test_quick_observe_dealloc_called
{
    dispatch_async(dispatch_get_main_queue(), ^{
        gObjectToObserveDeallocCount = 0;
        gObserverDeallocCount = 0;
        
        ObjectToObserve *objectToObserve = [ObjectToObserve new];
        Observer *observer = [Observer new];

        [observer observe:objectToObserve key:@"value" action:@selector(didChangeValue)];
    });
    
    XCTestExpectation *e = [self expectationWithDescription:@""];
    SafetyCallAfter(0.1, ^{
        [e fulfill];
    });

    [self waitForExpectationsWithTimeout:0.2 handler:^(NSError *_Nullable error) {
        XCTAssertEqual(gObserverDeallocCount, 1);
        XCTAssertEqual(gObjectToObserveDeallocCount, 1);
    }];
}

@end
