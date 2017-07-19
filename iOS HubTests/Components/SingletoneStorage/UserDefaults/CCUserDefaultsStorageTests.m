//
//  CCUserDefaultsStorageTests.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 20/05/16.
//  Copyright (c) 2016 FanHub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CCUserDefaultsStorage.h"

static NSString *kProfileKey = @"profile";

NSString *kCCProfileKeyFirstName = @"firstName";

@interface CCProfile : NSObject

@property (nonatomic, strong) NSString *firstName;

+ (instancetype)profileFromUserData:(NSDictionary *)dictionary;

@end

@implementation CCProfile

+ (instancetype)profileFromUserData:(NSDictionary *)dictionary
{
    CCProfile *profile = [CCProfile new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [profile setValue:obj forKey:key];
    }];
    return profile;
}


@end

@interface CCUserDefaultsStorageTests : XCTestCase

@property (nonatomic, strong) CCUserDefaultsStorage *storage;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation CCUserDefaultsStorageTests

- (void)setUp
{
    [super setUp];

    [self createStorage];
}

- (void)createStorage
{
    if (self.userDefaults) {
        [(id)self.userDefaults stopMocking];
    }
    if (self.storage) {
        [(id)self.storage stopMocking];
    }
    self.userDefaults = OCMPartialMock([NSUserDefaults standardUserDefaults]);

    self.storage = OCMPartialMock([[CCUserDefaultsStorage alloc] initWithClass:[CCProfile class] key:kProfileKey]);
    self.storage.userDefaults = self.userDefaults;
}

- (void)tearDown
{
    if (self.userDefaults) {
        [(id)self.userDefaults stopMocking];
    }
    if (self.storage) {
        [(id)self.storage stopMocking];
    }
    [super tearDown];
}

- (void)test_save_profile
{
    CCProfile *profile = [CCProfile profileFromUserData:@{
            kCCProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);


    CCProfile *loadedProfile = self.storage.getObject;
    XCTAssertEqualObjects(loadedProfile.firstName, @"alex");
}

- (void)test_load_profile_after_recreation
{
    CCProfile *profile = [CCProfile profileFromUserData:@{
            kCCProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    [self createStorage];

    CCProfile *loadedProfile = self.storage.getObject;
    XCTAssertEqualObjects(loadedProfile.firstName, @"alex");
    OCMVerify([_userDefaults objectForKey:kProfileKey]);
}

- (void)test_removes_profile_on_nil
{
    CCProfile *profile = [CCProfile profileFromUserData:@{
            kCCProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    //Remove
    [self.storage saveObject:nil];
    OCMVerify([_userDefaults setObject:nil forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    XCTAssertNil([self.storage getObject]);
}

- (void)test_removes_on_corrupted_data
{
    [self.userDefaults setObject:@"123123" forKey:kProfileKey];

    XCTAssertNotNil([self.userDefaults objectForKey:kProfileKey]);

    XCTAssertNil([self.storage getObject]);

    OCMVerify([_userDefaults setObject:nil forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    OCMVerify([self.storage deleteInstanceFromDisk]);

    XCTAssertNil([self.userDefaults objectForKey:kProfileKey]);
}

- (void)test_profile_saved_on_second_save_call
{
    CCProfile *profile = [CCProfile profileFromUserData:@{
            kCCProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);
}

@end
