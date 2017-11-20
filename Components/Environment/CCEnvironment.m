////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2016 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <objc/runtime.h>
#import "CCEnvironment.h"
#import "CCUserDefaultsStorage.h"
#import "CCLogger.h"
#import "CCMacroses.h"
#import "CCEnvironmentStorage.h"
#import "CCMacroses.h"
#import "CCCurrentEnvironmentStorage.h"
#import "CCNotificationUtils.h"

@interface CCEnvironment ()
@property (nonatomic) NSString *filename;
@end

static const char *kCCEnvironmentStorageKey = "_storage";

@implementation CCEnvironment {
    BOOL _batchSaveInProgress;
    BOOL _observing;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (CCEnvironmentStorage *)storage
{
    @synchronized (self) {
        CCEnvironmentStorage *result = GetAssociatedObjectFromObject(self, kCCEnvironmentStorageKey);
        if (!result) {
            result = [[CCEnvironmentStorage alloc] initWithEnvironmentClass:self];
            SetAssociatedObjectToObject(self, kCCEnvironmentStorageKey, result);
        }
        return result;
    }
}

+ (instancetype)currentEnvironment
{
    return self.storage.currentStorage.current;
}

+ (void)setCurrentEnvironment:(__kindof CCEnvironment *)environment
{
    self.storage.currentStorage.current = environment;
}

+ (void)resetAll
{
    for (__kindof CCEnvironment *environment in [self.storage availableEnvironments]) {
        if ([self.storage canResetEnvironment:environment]) {
            [self.storage resetEnvironment:environment];
        } else {
            [self.storage deleteEnvironment:environment];
        }
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (void)connectToStorage
{
    [self setupObserving];
}

- (void)dealloc
{
    [self stopObserving];
}

- (void)setupObserving
{
    if (_observing) {
        return;
    }

    _observing = YES;

    for (NSString *propertyName in [[self class] allPropertyKeys]) {
        [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:NULL];
    }

    [self registerForNotification:CCEnvironmentStorageDidSaveNotification selector:@selector(didSaveStorage:)];
}

- (void)stopObserving
{
    if (!_observing) {
        return;
    }

    for (NSString *propertyName in [[self class] allPropertyKeys]) {
        [self removeObserver:self forKeyPath:propertyName];
    }

    _observing = NO;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

+ (NSArray<__kindof CCEnvironment *> *)availableEnvironments
{
    return [self.storage availableEnvironments];
}

+ (instancetype)duplicate:(__kindof CCEnvironment *)environment
{
    return [self.storage createEnvironmentByDuplicating:environment];
}


- (void)batchSave:(dispatch_block_t)saveBlock
{
    [self withoutSave:saveBlock];
    [self performSave];
}

- (void)withoutSave:(void(^)())block
{
    _batchSaveInProgress = YES;
    CCSafeCall(block);
    _batchSaveInProgress = NO;
}

- (BOOL)canReset
{
    return [[self storage] canResetEnvironment:self];
}

- (void)reset
{
    [[self storage] resetEnvironment:self];
}

- (BOOL)canDelete
{
    return ![self canReset];
}

- (void)delete
{
    [[self storage] deleteEnvironment:self];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

+ (NSArray<NSString *> *)environmentFilenames
{
    return @[];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (CCEnvironmentStorage *)storage
{
    return [(__kindof CCEnvironment *)[self class] storage];
}

- (NSString *)name
{
    return _name ?: self.filename;
}

- (void)copyPropertiesFrom:(CCEnvironment *)anotherEnvironment
{
    for (NSString *key in [[self class] allPropertyKeys]) {
        id value = [anotherEnvironment valueForKey:key];
        if (value) {
            [self setValue:value forKey:key];
        } else {
            [self setNilValueForKey:key];
        }
    }
}

- (void)didSaveStorage:(NSNotification *)notification
{
    __kindof CCEnvironment *savedEnvironment = notification.object;

    BOOL shouldReloadProperties = [self isMemberOfClass:savedEnvironment.class] &&
            [savedEnvironment.filename isEqualToString:self.filename];

    if (shouldReloadProperties) {
        [self withoutSave:^{
           [self copyPropertiesFrom:savedEnvironment];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self saveIfNeeded];
}

- (void)saveIfNeeded
{
    if (!_batchSaveInProgress) {
        [self performSave];
    }
}

- (void)performSave
{
    [[self storage] saveEnvironment:self];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Copying
//-------------------------------------------------------------------------------------------

- (id)copyWithZone:(nullable NSZone *)zone
{
    __kindof CCEnvironment *copy = (__kindof CCEnvironment *)[[self class] new];

    [copy copyPropertiesFrom:self];

    return copy;
}

@end
