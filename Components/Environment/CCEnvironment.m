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


@implementation CCEnvironment {
    CCUserDefaultsStorage *_nameStorage;
    BOOL _batchSaveInProgress;
    BOOL _observing;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype) init
{
    if (!(self = [super init])) {
        return nil;
    }

    _nameStorage = [CCUserDefaultsStorage withClass:[NSString class] key:@"EnvironmentName"];
    NSString *name = [_nameStorage getObject];

    if (!name) {
        name = [[[self class] environmentFilenames] firstObject];
    }
    if (!name) {
        DDLogError(@"0 environments found!");
        return self;
    }

    CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:[self class] key:name];
    id object = [storage getObject];

    if (!object) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        object = [self initWithContentsOfFile:path];
    }

    if (!object) {
        return nil;
    }

    self = object;

    [self setupObserving];

    return self;
}

- (void)dealloc
{
    [self stopObserving];
}

+ (CCEnvironment *)environmentFromName:(NSString *)name
{
    CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:[self class] key:name];
    id object = [storage getObject];

    if (!object) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        object = [self instanceWithContentsOfFile:path];
    }

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

+ (NSArray<CCEnvironment *> *)availableEnvironments
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
    [self batchSave:^{
        for (NSString *key in [[self class] allPropertyKeys]) {
            id value = [environment valueForKey:key];
            [self setValue:value forKey:key];
        }
    }];

    [_nameStorage saveObject:environment.filename];
}

- (void)batchSave:(dispatch_block_t)saveBlock
{
    _batchSaveInProgress = YES;
    SafetyCall(saveBlock);
    _batchSaveInProgress = NO;

    [self performSave];
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
    CCUserDefaultsStorage *storage = [CCUserDefaultsStorage withClass:[self class] key:[_nameStorage getObject]];
    [storage saveObject:self];
}

@end
