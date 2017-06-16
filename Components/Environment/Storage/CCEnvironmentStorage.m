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


@interface CCOrderedDictionary<KeyType, ObjectType> : NSObject

@property (nonatomic, strong) NSMutableOrderedSet *orderedKeys;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSArray *)allValues;
@end

@implementation CCOrderedDictionary

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.orderedKeys = [NSMutableOrderedSet new];
        self.dictionary = [NSMutableDictionary new];
    }

    return self;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    self.dictionary[aKey] = anObject;
    [self.orderedKeys addObject:aKey];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    self.dictionary[key] = obj;
    [self.orderedKeys addObject:key];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    for (id key in self.orderedKeys) {
        id object = self.dictionary[key];
        BOOL stop = NO;
        SafetyCall(block, key, object, &stop);
        if (stop) {
            break;
        }
    }
}

- (id)objectForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (id)objectForKeyedSubscript:(id)key
{
    return self.dictionary[key];
}

- (NSArray *)allValues
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.dictionary.count];

    for (id key in self.orderedKeys) {
        [result addObject:self.dictionary[key]];
    }

    return result;
}

@end


@implementation CCEnvironmentStorage
{
    CCOrderedDictionary<NSString *, __kindof CCEnvironment *> *_environmentsPerName;
    CCUserDefaultsStorage *_userDefaultsStorage;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Instance methods
//-------------------------------------------------------------------------------------------

- (instancetype)initWithEnvironmentClass:(Class)clazz
{
    self = [super init];
    if (self) {
        _environmentsPerName = [CCOrderedDictionary new];
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
    return [_environmentsPerName allValues];
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
    _userDefaultsStorage = [[CCUserDefaultsStorage alloc] initWithClass:[CCOrderedDictionary class] key:userDefaultsKey];

    if (![_userDefaultsStorage getObject]) {
        [_userDefaultsStorage saveObject:[CCOrderedDictionary new]];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Plist files
//-------------------------------------------------------------------------------------------

- (void)loadFromPlistToUserDefaultsWhereEmpty
{
    CCOrderedDictionary *allEnvironments = [_userDefaultsStorage getObject];

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
    CCOrderedDictionary *environmentsInUserDefaults = [_userDefaultsStorage getObject];

    [environmentsInUserDefaults enumerateKeysAndObjectsUsingBlock:^(NSString *name, __kindof CCEnvironment *environment, BOOL *stop) {
        [environment connectToStorage];
        [_environmentsPerName setObject:environment forKey:name];
    }];
}

- (void)saveEnvironment:(__kindof CCEnvironment *)environment
{
    CCOrderedDictionary *environmentsInUserDefaults = [_userDefaultsStorage getObject];
    environmentsInUserDefaults[environment.filename] = environment;
    [_userDefaultsStorage saveCurrentObject];

    [NSNotificationCenter postNotification:CCEnvironmentStorageDidSaveNotification withObject:environment];
}

@end