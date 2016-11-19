//
//  DTUserDefaultsStorageTests.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 20/05/16.
//  Copyright (c) 2016 FanHub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DTUserDefaultsStorage.h"
//#import "DTProfile.h"
//#import "DTProfileKeys.h"

static NSString *kProfileKey = @"profile";


NSString *kDTProfileKeyFirstName = @"firstName";

@interface DTProfile : NSObject

@property (nonatomic, strong) NSString *firstName;

+ (instancetype)profileFromUserData:(NSDictionary *)dictionary;

@end

@implementation DTProfile

+ (instancetype)profileFromUserData:(NSDictionary *)dictionary
{
    DTProfile *profile = [DTProfile new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [profile setValue:obj forKey:key];
    }];
    return profile;
}


@end

@interface DTUserDefaultsStorageTests : XCTestCase

@property (nonatomic, strong) DTUserDefaultsStorage *storage;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation DTUserDefaultsStorageTests

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

    self.storage = OCMPartialMock([[DTUserDefaultsStorage alloc] initWithClass:[DTProfile class] key:kProfileKey]);
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
    DTProfile *profile = [DTProfile profileFromUserData:@{
            kDTProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);


    DTProfile *loadedProfile = self.storage.getObject;
    XCTAssertEqualObjects(loadedProfile.firstName, @"alex");
}

- (void)test_load_profile_after_recreation
{
    DTProfile *profile = [DTProfile profileFromUserData:@{
            kDTProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    [self createStorage];

    DTProfile *loadedProfile = self.storage.getObject;
    XCTAssertEqualObjects(loadedProfile.firstName, @"alex");
    OCMVerify([_userDefaults objectForKey:kProfileKey]);
}

- (void)test_removes_profile_on_nil
{
    DTProfile *profile = [DTProfile profileFromUserData:@{
            kDTProfileKeyFirstName: @"alex"
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
    DTProfile *profile = [DTProfile profileFromUserData:@{
            kDTProfileKeyFirstName: @"alex"
    }];

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);

    [self.storage saveObject:profile];
    OCMVerify([_userDefaults setObject:[OCMArg any] forKey:kProfileKey]);
    OCMVerify([_userDefaults synchronize]);
}

@end
