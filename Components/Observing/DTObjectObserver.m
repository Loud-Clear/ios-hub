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
#import "DTObjectObserver.h"
#import "KVOController.h"

@interface DTObservationInfo : NSObject

@property (nonatomic, copy) void(^block)();
@property (nonatomic, copy) void(^blockChange)(NSArray* keys, NSDictionary *change);
@property (nonatomic) SEL action;
@property (nonatomic) NSSet *observedKeys;
@property (nonatomic) CGFloat batchUpdateDelay;

@property (nonatomic, strong) NSMutableDictionary *changes;

- (void)notifyChangeWithTarget:(id)target key:(NSString *)key change:(NSDictionary *)change;

@end

@implementation DTObservationInfo {
    BOOL _notificationScheduled;
}

- (void)notifyChangeWithTarget:(id)target key:(NSString *)key change:(NSDictionary *)change
{
	if(!self.changes) {
        self.changes = [NSMutableDictionary dictionary];
    }

	self.changes[key] = [change copy];
	
    if (!_notificationScheduled) {
        _notificationScheduled = YES;
        void(^notificationBlock)() = ^{
            SafetyCall(self.block);
			SafetyCall(self.blockChange, [self.observedKeys allObjects], self.changes);
			_notificationScheduled = NO;
			self.changes = nil;
            if (self.action) {
                SuppressPerformSelectorLeakWarning(
                        [target performSelector:self.action]
                );
            }
        };

        if (self.batchUpdateDelay > 0) {
            SafetyCallAfter(self.batchUpdateDelay, notificationBlock);
        } else {
            SafetyCall(notificationBlock);
        }
    }
}

@end



@implementation DTObjectObserver
{
    id _objectToObserve;
    __weak id _observer;

    NSMutableSet *_observedKeys;

    NSMutableArray<DTObservationInfo *> *_observers;

    FBKVOController *_kvoController;
}

- (id)objectToObserve
{
    return _objectToObserve;
}

- (id)observer
{
    return _observer;
}

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

        if ([_objectToObserve isKindOfClass:[RLMObject class]]) {
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
    NSAssert([_objectToObserve isKindOfClass:[RLMObject class]], @"object must be realm object");
    [self observeKeys:@[@"invalidated"] withAction:action];
}

- (void)observeInvalidationWithBlock:(void (^)())block
{
    NSAssert([_objectToObserve isKindOfClass:[RLMObject class]], @"object must be realm object");
    [self observeKeys:@[@"invalidated"] withBlock:block];
}

- (void)observeKeys:(NSArray *)keys withAction:(SEL)action
{
    DTObservationInfo *info = [DTObservationInfo new];
    info.action = action;
    info.observedKeys = [NSSet setWithArray:keys];
    [self addObserverWithInfo:info];
}

- (void)observeKeys:(NSArray *)keys withBlock:(void(^)())block
{
    DTObservationInfo *info = [DTObservationInfo new];
    info.block = block;
    info.observedKeys = [NSSet setWithArray:keys];
    [self addObserverWithInfo:info];
}

- (void)observeKeys:(NSArray *)keys withBlockChange:(void(^)(NSArray* keys, NSDictionary* change))block
{
	DTObservationInfo *info = [DTObservationInfo new];
	info.blockChange = block;
	info.observedKeys = [NSSet setWithArray:keys];
	[self addObserverWithInfo:info];
}

- (void)addObserverWithInfo:(DTObservationInfo *)info
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
        BOOL isSerializableKey = [self isSerializableKeyPath:key forInstance:_objectToObserve];
        if (isSerializableKey) {
            keyToObserve = [self dataKeyFromObjectKey:key];
        }

        [_kvoController observe:_objectToObserve keyPath:keyToObserve options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
                                  @strongify(self)
                                  if (isSerializableKey) {
                                      change = [self deserializeValuesInChangeDictionary:change
                                                                           withObjectKey:key instance:self.objectToObserve];
                                  }
                                  [self didChangeObservedValueForKey:key change:change];
                              }];
    }
}

- (void)didChangeObservedValueForKey:(NSString *)key change:(NSDictionary *)change
{
    @weakify(self)
    [self enumerateObserversForKey:key usingBlock:^(DTObservationInfo *info) {
        @strongify(self)
        [info notifyChangeWithTarget:[self observer] key:key change:change];
    }];
}

- (void)enumerateObserversForKey:(NSString *)key usingBlock:(void(^)(DTObservationInfo *info))block
{
    for (DTObservationInfo *info in _observers) {
        if ([info.observedKeys containsObject:key]) {
            SafetyCall(block, info);
        }
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Serialized JSON properties handling
//-------------------------------------------------------------------------------------------

- (BOOL)isSerializableKeyPath:(NSString *)key forInstance:(id)instance
{
    NSArray *pathComponents = [key componentsSeparatedByString:@"."];

    if ([pathComponents count] > 1) {
        NSArray *pathToPrevious = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 1)];
        NSString *keyPathToPrevious = [pathToPrevious componentsJoinedByString:@"."];
        id parentInstance = [instance valueForKeyPath:keyPathToPrevious];
        return [self isSerializableKeyPath:[pathComponents lastObject] forInstance:parentInstance];
    } else if ([pathComponents count] == 1) {
        if ([[instance class] respondsToSelector:@selector(serializedProperties)]) {
            //checking only one
            NSArray *serializableKeys = [[instance class] serializedProperties];
            return [serializableKeys containsObject:key];
        }
    }
    return NO;
}

- (NSString *)dataKeyFromObjectKey:(NSString *)key
{
    NSMutableArray *pathComponents = [[key componentsSeparatedByString:@"."] mutableCopy];

    if ([pathComponents count] > 1) {
        //Replacing last component
        NSString *dataKey = DTDataPropertyNameFromName([pathComponents lastObject]);
        pathComponents[[pathComponents count] - 1] = dataKey;
        return [pathComponents componentsJoinedByString:@"."];
    }
    else if ([pathComponents count] == 1) {
        return DTDataPropertyNameFromName(key);
    }

    return key;
}

- (NSDictionary *)deserializeValuesInChangeDictionary:(NSDictionary *)dictionary withObjectKey:(NSString *)objectKey instance:(id)instance
{
    TyphoonTypeDescriptor *type = nil;
    NSArray *pathComponents = [objectKey componentsSeparatedByString:@"."];

    if ([pathComponents count] > 1) {
        NSArray *pathToPrevious = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 1)];
        NSString *keyPathToPrevious = [pathToPrevious componentsJoinedByString:@"."];
        id parentInstance = [instance valueForKeyPath:keyPathToPrevious];
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:[pathComponents lastObject] inClass:[parentInstance class]];
    }
    else if ([pathComponents count] == 1) {
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:objectKey inClass:[instance class]];
    }

    NSMutableDictionary *result = [dictionary mutableCopy];

    result[NSKeyValueChangeOldKey] = [self deserializeString:dictionary[NSKeyValueChangeOldKey] toType:type];
    result[NSKeyValueChangeNewKey] = [self deserializeString:dictionary[NSKeyValueChangeNewKey] toType:type];

    return result;
}

- (id)deserializeString:(NSString *)string toType:(TyphoonTypeDescriptor *)type
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return [(id<DTDatabaseJSONSerialization>)[type.typeBeingDescribed alloc] initWithJSONObject:jsonObject];
}

@end
