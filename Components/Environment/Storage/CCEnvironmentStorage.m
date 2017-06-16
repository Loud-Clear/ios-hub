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

#import "CCEnvironmentStorage.h"
#import "CCEnvironment.h"
#import "CCUserDefaultsStorage.h"
#import "CCMacroses.h"
#import "CCEnvironment+Private.h"
#import "CCCurrentEnvironmentStorage.h"
#import "CCNotificationUtils.h"

static NSString *CCEnvironmentTransientPrefix = @"__transient_";

NSString *CCEnvironmentStorageDidSaveNotification = @"CCEnvironmentStorageDidSaveNotification";

@implementation CCEnvironmentStorage
{
    NSMapTable<NSString *, __kindof CCEnvironment *> *_environmentsPerName;
    CCUserDefaultsStorage *_userDefaultsStorage;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Instance methods
//-------------------------------------------------------------------------------------------

- (instancetype)initWithEnvironmentClass:(Class)clazz
{
    self = [super init];
    if (self) {
        _environmentsPerName = [NSMapTable strongToStrongObjectsMapTable];
        self.environmentClass = clazz;

        [self setupUserDefaultsStorage];

        [self loadFromPlistToUserDefaultsWhereEmpty];
        [self loadUserDefaultsToMemory];

        self.currentStorage = [[CCCurrentEnvironmentStorage alloc] initWithStorage:self];
    }
    return self;
}

- (NSArray<__kindof CCEnvironment *> *)availableEnvironments
{
    NSMutableArray *environments = [NSMutableArray new];

    NSEnumerator *keyEnumerator = [_environmentsPerName keyEnumerator];
    NSString *key = nil;
    while ((key = [keyEnumerator nextObject])) {
        [environments addObject:[_environmentsPerName objectForKey:key]];
    }

    return environments;
}

- (__kindof CCEnvironment *)environmentWithName:(NSString *)name
{
    return [_environmentsPerName objectForKey:name];
}

- (BOOL)canResetEnvironment:(__kindof CCEnvironment *)environment
{
    return ![environment.filename hasPrefix:CCEnvironmentTransientPrefix];
}

- (void)resetEnvironment:(__kindof CCEnvironment *)environment
{
    NSAssert([self canResetEnvironment:environment], @"Can't reset environment which is not loaded from plist");

    __kindof CCEnvironment *original = [self environmentFromPlistWithName:environment.filename];

    [environment batchSave:^{
        [environment copyPropertiesFrom:original];
    }];
}

- (__kindof CCEnvironment *)createEnvironmentByDuplicating:(__kindof CCEnvironment *)environment
{
    __kindof CCEnvironment *duplicate = [environment copy];

    duplicate.filename = [NSString stringWithFormat:@"%@%@",CCEnvironmentTransientPrefix, [[NSUUID UUID] UUIDString]];
    duplicate.name = [NSString stringWithFormat:@"%@ copy", environment.name];

    [_environmentsPerName setObject:duplicate forKey:duplicate.filename];

    [self saveEnvironment:duplicate];

    [duplicate connectToStorage];

    return duplicate;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private methods
//-------------------------------------------------------------------------------------------

- (void)setupUserDefaultsStorage
{
    NSString *userDefaultsKey = [NSString stringWithFormat:@"cc_environment_%@", NSStringFromClass(self.environmentClass)];
    _userDefaultsStorage = [[CCUserDefaultsStorage alloc] initWithClass:[NSMutableDictionary class] key:userDefaultsKey];

    if (![_userDefaultsStorage getObject]) {
        [_userDefaultsStorage saveObject:[NSMutableDictionary new]];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Plist files
//-------------------------------------------------------------------------------------------

- (void)loadFromPlistToUserDefaultsWhereEmpty
{
    NSMutableDictionary *allEnvironments = [_userDefaultsStorage getObject];

    for (NSString *filename in [self.environmentClass environmentFilenames]) {
        if (!allEnvironments[filename]) {
            CCEnvironment *environment = [self environmentFromPlistWithName:filename];
            if (environment) {
                allEnvironments[filename] = environment;
            }
        }
    }

    [_userDefaultsStorage saveCurrentObject];
}

- (__kindof CCEnvironment *)environmentFromPlistWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    __kindof CCEnvironment *result = (__kindof CCEnvironment *)[self.environmentClass instanceWithContentsOfFile:path];
    result.filename = name;
    if (!result) {
        DDLogError(@"Can't load environment from plist name '%@'", name);
    }
    return result;
}

//-------------------------------------------------------------------------------------------
#pragma mark - User Defaults
//-------------------------------------------------------------------------------------------

- (void)loadUserDefaultsToMemory
{
    NSDictionary *environmentsInUserDefaults = [_userDefaultsStorage getObject];

    [environmentsInUserDefaults enumerateKeysAndObjectsUsingBlock:^(NSString *name, __kindof CCEnvironment *environment, BOOL *stop) {
        [environment connectToStorage];
        [_environmentsPerName setObject:environment forKey:name];
    }];
}

- (void)saveEnvironment:(__kindof CCEnvironment *)environment
{
    NSMutableDictionary *environmentsInUserDefaults = [_userDefaultsStorage getObject];
    environmentsInUserDefaults[environment.filename] = environment;
    [_userDefaultsStorage saveCurrentObject];

    [NSNotificationCenter postNotificationToMainThread:CCEnvironmentStorageDidSaveNotification withObject:environment];
}

@end