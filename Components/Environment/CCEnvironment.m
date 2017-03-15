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

#import "CCEnvironment.h"
#import "CCUserDefaultsStorage.h"
#import "CCLogger.h"
#import "CCMacroses.h"

@interface CCEnvironment ()
@property (nonatomic) NSString *filename;
@end


@implementation CCEnvironment {
    BOOL _initializing;
    CCUserDefaultsStorage *_nameStorage;
    BOOL _batchSaveInProgress;
    BOOL _observing;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initCurrent
{
    if (!(self = [super init])) {
        return nil;
    }

    if (_initializing) {
        return self;
    }

    _initializing = YES;

    _nameStorage = [CCUserDefaultsStorage withClass:[NSString class] key:@"EnvironmentName"];
    NSString *name = [_nameStorage getObject];
    BOOL nameWasNil = NO;

    if (!name) {
        nameWasNil = YES;
        name = [[[self class] environmentFilenames] firstObject];
    }
    if (!name) {
        DDLogError(@"0 environments found!");
        return self;
    }

    CCEnvironment *object = [[self class]environmentFromName:name];
    if (!object) {
        return nil;
    }

    if (nameWasNil) {
        [_nameStorage saveObject:name];
    }

    [self useEnvironment:object];

    [self setupObserving];

    _initializing = NO;

    return self;
}

- (void)dealloc
{
    [self stopObserving];
}

+ (CCEnvironment *)environmentFromName:(NSString *)name
{
    CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:self key:name];
    CCEnvironment *object = [storage getObject];

    if (!object) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        object = [self instanceWithContentsOfFile:path];
    }

    object.filename = name;

    return object;
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

+ (instancetype)currentEnvironment
{
    return [[self alloc] initCurrent];
}

+ (NSArray<__kindof CCEnvironment *> *)availableEnvironments
{
    NSMutableArray<CCEnvironment *> *envs = [NSMutableArray new];

    for (NSString *filename in [self environmentFilenames]) {
        CCEnvironment *env = [self environmentFromName:filename];
        if (env) {
            [envs addObject:env];
        }
    }

    return envs;
}

- (void)useEnvironment:(CCEnvironment *)environment
{
    if (!environment.filename) {
        NSAssert(NO, nil);
        return;
    }

    [self batchSave:^{
        for (NSString *key in [[self class] allPropertyKeys]) {
            id value = [environment valueForKey:key];
            [self setValue:value forKey:key];
        }
        [_nameStorage saveObject:environment.filename];
    }];
}

- (void)batchSave:(dispatch_block_t)saveBlock
{
    _batchSaveInProgress = YES;
    SafetyCall(saveBlock);
    _batchSaveInProgress = NO;

    [self performSave];
}

+ (void)reset
{
    if ([self isEqual:[CCEnvironment class]]) {
        DDLogWarn(@"[%@ reset]: must likely you wanted to call +reset on your subclass, not base %@ class.", NSStringFromClass([CCEnvironment class]), NSStringFromClass([CCEnvironment class]));
        NSAssert(NO, nil);
    }

    NSArray<NSString *> *names = [self environmentFilenames];

    for (NSString *name in names) {
        CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:self key:name];
        [storage deleteInstanceFromDisk];
    }
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
    NSString *name = [_nameStorage getObject];
    if (!name) {
        NSAssert(NO, nil);
        return;
    }

    CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:[self class] key:[_nameStorage getObject]];
    [storage saveObject:self];
}

@end
