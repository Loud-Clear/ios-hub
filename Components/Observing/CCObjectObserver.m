////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Typhoon/TyphoonIntrospectionUtils.h>
#import <Typhoon/TyphoonTypeDescriptor.h>
#import "CCObjectObserver.h"
#import "KVOController.h"
#import "CCMacroses.h"
#import "CCObservationInfo.h"


@protocol CCObjectObserverDatabaseSerialization <NSObject>

- (BOOL)isSerializableKeyPath:(NSString *)key forInstance:(id)instance;

- (NSString *)dataKeyFromObjectKey:(NSString *)key;

- (NSDictionary *)deserializeValuesInChangeDictionary:(NSDictionary *)dictionary withObjectKey:(NSString *)objectKey instance:(id)instance;

@end


@implementation CCObjectObserver
{
    id _objectToObserve;
    __weak id _observer;

    NSMutableSet *_observedKeys;

    NSMutableArray<CCObservationInfo *> *_observers;

    FBKVOController *_kvoController;
    NSArray<NSString *> *_pausedKeys;
}

- (id)objectToObserve
{
    return _objectToObserve;
}

- (id)observer
{
    return _observer;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithObject:(id)objectToObserve observer:(id)observer
{
    if (!objectToObserve) {
        return nil;
    }

    self = [super init];
    if (self) {
        _objectToObserve = objectToObserve;
        _observer = observer;

        _observedKeys = [NSMutableSet new];
        _observers = [NSMutableArray new];

        _kvoController = self.KVOControllerNonRetaining;

        if ([_objectToObserve isKindOfClass:[self realmObjectClass]]) {
            @weakify(self)
            [self observeInvalidationWithBlock:^{
                @strongify(self)
                [self stopAndInvalidate];
            }];
        }
    }
    return self;
}

- (void)stopAndInvalidate
{
    [_kvoController unobserveAll];
    [_observedKeys removeAllObjects];
    _objectToObserve = nil;
}

- (void)dealloc
{
    [self stopAndInvalidate];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)connectKey:(NSString *)srcKey to:(UILabel *)label
{
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        label.text = [[[self objectToObserve] valueForKeyPath:srcKey] description];
    };
    
    [self observeKeys:@[srcKey] withBlock:block];
    block();
}

- (void)connectKey:(NSString *)srcKey to:(NSString *)dstKey on:(id)dstObject
{
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [dstObject setValue:[[self objectToObserve] valueForKeyPath:srcKey] forKeyPath:dstKey];
    };
    
    [self observeKeys:@[srcKey] withBlock:block];
    block();
}

- (void)connectKey:(NSString *)srcKey to:(NSString *)dstKey on:(id)dstObject onChanges:(NSArray *)observationKeys
{
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [dstObject setValue:[[self objectToObserve] valueForKeyPath:srcKey] forKeyPath:dstKey];
    };
    
    [self observeKeys:observationKeys withBlock:block];
    block();
}

- (void)observeInvalidationWithAction:(SEL)action
{
    NSAssert([_objectToObserve isKindOfClass:[self realmObjectClass]], @"object must be realm object");
    [self observeKeys:@[@"invalidated"] withAction:action];
}

- (void)observeInvalidationWithBlock:(dispatch_block_t)block
{
    NSAssert([_objectToObserve isKindOfClass:[self realmObjectClass]], @"object must be realm object");
    [self observeKeys:@[@"invalidated"] withBlock:block];
}

- (void)observeKeys:(NSArray *)keys withAction:(SEL)action
{
    CCObservationInfo *info = [CCObservationInfo new];
    info.action = action;
    info.observedKeys = [NSSet setWithArray:keys];
    [self addObserverWithInfo:info];
}

- (void)observeKeys:(NSArray *)keys withBlock:(dispatch_block_t)block
{
    CCObservationInfo *info = [CCObservationInfo new];
    info.block = block;
    info.observedKeys = [NSSet setWithArray:keys];
    [self addObserverWithInfo:info];
}

- (void)observeKeys:(NSArray *)keys withBlockChange:(void(^)(NSArray* keys, NSDictionary* change))block
{
	CCObservationInfo *info = [CCObservationInfo new];
	info.blockChange = block;
	info.observedKeys = [NSSet setWithArray:keys];
	[self addObserverWithInfo:info];
}

- (void)unobserveKeys:(NSArray *)keys
{
    NSSet *keysAsSet = nil;

    for (CCObservationInfo *info in [_observers reverseObjectEnumerator])
    {
        if (!keysAsSet) {
            keysAsSet = [NSSet setWithArray:keys];
        }

        if ([info.observedKeys isEqualToSet:keysAsSet])
        {
            for (NSString *key in info.observedKeys) {
                [_kvoController unobserve:_objectToObserve keyPath:key];
            }

            [_observers removeObject:info];
        }
        else
        {
            // TODO: write tests for this logic.
            NSMutableSet *intersection = [info.observedKeys mutableCopy];
            [intersection intersectSet:keysAsSet];

            for (NSString *key in intersection) {
                [_kvoController unobserve:_objectToObserve keyPath:key];
            }

            NSMutableSet *newObservedKeys = [info.observedKeys mutableCopy];
            [newObservedKeys minusSet:intersection];
            info.observedKeys = newObservedKeys;

            if ([newObservedKeys count] == 0) {
                [_observers removeObject:info];
            }
        }
    }
}

- (void)unobserveAllKeys
{
    [self unobserveKeys:[_observedKeys allObjects]];
}

- (NSUInteger)observationsCount
{
    return [_observers count];
}

- (void)pauseObservationForKeys:(NSArray *)keys forBlock:(void(^)(void))block
{
    _pausedKeys = keys;
    CCSafeCall(block);
    _pausedKeys = nil;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)addObserverWithInfo:(CCObservationInfo *)info
{
    info.batchUpdateDelay = [info.observedKeys count] > 1 ? 0.1f : 0;
    [_observers addObject:info];
    for (NSString *key in info.observedKeys) {
        [self observeKeyIfNeeded:key];
    }
}

- (void)observeKeyIfNeeded:(NSString *)key
{
    if (![_observedKeys containsObject:key]) {
        [_observedKeys addObject:key];
        @weakify(self)

        NSString *keyToObserve = key;
        BOOL isSerializableKey = NO;
        
        if ([self hasDatabaseAdditionals]) {
            isSerializableKey = [self.databaseAddon isSerializableKeyPath:key forInstance:_objectToObserve];
            if (isSerializableKey) {
                keyToObserve = [self.databaseAddon dataKeyFromObjectKey:key];
            }
        }
    
        [_kvoController observe:_objectToObserve keyPath:keyToObserve options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
                                  @strongify(self)
                                  if (isSerializableKey) {
                                      change = [self.databaseAddon deserializeValuesInChangeDictionary:change
                                                                                         withObjectKey:key
                                                                                              instance:self.objectToObserve];
                                  }
                                  [self didChangeObservedValueForKey:key change:change];
                              }];
    }
}

- (void)didChangeObservedValueForKey:(NSString *)key change:(NSDictionary *)change
{
    if (_pausedKeys && [_pausedKeys containsObject:key]) {
        //Skip observation actions
        return;
    }

    @weakify(self)
    [self enumerateObserversForKey:key usingBlock:^(CCObservationInfo *info) {
        @strongify(self)
        [info notifyChangeWithTarget:[self observer] key:key change:change];
    }];
}

- (void)enumerateObserversForKey:(NSString *)key usingBlock:(void(^)(CCObservationInfo *info))block
{
    for (CCObservationInfo *info in _observers) {
        if ([info.observedKeys containsObject:key]) {
            CCSafeCall(block, info);
        }
    }
}

- (Class)realmObjectClass
{
    return NSClassFromString(@"RLMObject");
}

- (BOOL)hasDatabaseAdditionals
{
    return [self respondsToSelector:@selector(isSerializableKeyPath:forInstance:)];
}

- (id<CCObjectObserverDatabaseSerialization>)databaseAddon
{
    if ([self hasDatabaseAdditionals]) {
        return (id)self;
    } else {
        return nil;
    }
}


@end
