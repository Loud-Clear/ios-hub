////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCCurrentEnvironmentStorage.h"
#import "CCUserDefaultsStorage.h"
#import "CCEnvironmentStorage.h"
#import "CCEnvironment.h"
#import "CCEnvironment+Private.h"

NSString * kCCEnvironmentCurrentKey = @"cc_current_environment";


@implementation CCCurrentEnvironmentStorage
{
    CCUserDefaultsStorage *_currentEnvironmentName;
    __weak CCEnvironmentStorage *_storage;
    __kindof CCEnvironment *_currentEnvironment;
}

- (instancetype)initWithStorage:(CCEnvironmentStorage *)storage
{
    self = [super init];
    if (self) {
        _storage = storage;
        _currentEnvironmentName = [[CCUserDefaultsStorage alloc] initWithClass:[NSString class] key:kCCEnvironmentCurrentKey];

        [self setupCurrentEnvironment];
    }
    return self;
}

- (void)setupCurrentEnvironment
{
    __kindof CCEnvironment *environment = [_storage environmentWithName:[self currentName]];
    _currentEnvironment = [environment copy];
    [_currentEnvironment connectToStorage];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface methods
//-------------------------------------------------------------------------------------------

- (void)setCurrent:(__kindof CCEnvironment *)current
{
    [self setCurrentName:current.filename];

    [_currentEnvironment withoutSave:^{
        [_currentEnvironment copyPropertiesFrom:current];
    }];
}

- (__kindof CCEnvironment *)current
{
    return _currentEnvironment;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Name
//-------------------------------------------------------------------------------------------

- (NSString *)currentName
{
    NSString *currentName = [_currentEnvironmentName getObject];
    if (!currentName) {
        currentName = [[_storage.environmentClass environmentFilenames] firstObject];
    }
    return currentName;
}

- (void)setCurrentName:(NSString *)name
{
    [_currentEnvironmentName saveObject:name];
}


@end