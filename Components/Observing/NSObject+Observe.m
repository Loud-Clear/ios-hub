////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <objc/runtime.h>
#import "NSObject+Observe.h"
#import "CCObjectObserver.h"
#import "CCMacroses.h"


@interface NSObject ()

@property (nonatomic, readonly) NSMapTable<id, id> *cc_observers;

@end


@implementation NSObject (CCObserve)

- (void)observe:(id)object key:(NSString *)key action:(SEL)action
{
    if (!key) {
        NSParameterAssert(key);
        return;
    }

    [self observe:object keys:@[key] action:action];
}

- (void)observe:(id)object key:(NSString *)key block:(dispatch_block_t)block
{
    if (!key) {
        NSParameterAssert(key);
        return;
    }

    [self observe:object keys:@[key] block:block];
}

- (void)observe:(id)object keys:(NSArray<NSString *> *)keys action:(SEL)action
{
    CCObjectObserver *observer = [self observerForObject:object];
    [observer unobserveKeys:keys];
    [observer observeKeys:keys withAction:action];
}

- (void)observe:(id)object keys:(NSArray<NSString *> *)keys block:(dispatch_block_t)block
{
    CCObjectObserver *observer = [self observerForObject:object];
    [observer unobserveKeys:keys];
    [observer observeKeys:keys withBlock:block];
}

- (void)unobserve:(id)object
{
    CCObjectObserver *observer = [self.cc_observers objectForKey:object];

    if (!observer) {
        return;
    }

    [observer unobserveAllKeys];

    if ([observer observationsCount] == 0) {
        [self.cc_observers removeObjectForKey:object];
    }
}

- (void)unobserve:(id)object key:(NSString *)key
{
    if (!key) {
        NSParameterAssert(key);
        return;
    }

    CCObjectObserver *observer = [self.cc_observers objectForKey:object];

    if (!observer) {
        return;
    }

    [observer unobserveKeys:@[key]];

    if ([observer observationsCount] == 0) {
        [self.cc_observers removeObjectForKey:object];
    }
}

- (void)unobserveKey:(NSString *)key
{
    if (!key) {
        NSParameterAssert(key);
        return;
    }

    NSMutableSet *observersKeysToDelete = [NSMutableSet new];

    for (id object in self.cc_observers)
    {
        CCObjectObserver *observer = [self.cc_observers objectForKey:object];
        [observer unobserveKeys:@[key]];

        if ([observer observationsCount] == 0) {
            [observersKeysToDelete addObject:object];
        }
    }

    for (id object in observersKeysToDelete) {
        [self.cc_observers removeObjectForKey:object];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (NSMapTable<id, id> *)cc_observers
{
    NSMapTable<id, id> *observers = GetAssociatedObject(@selector(cc_observers));

    if (!observers) {
        observers = [NSMapTable weakToStrongObjectsMapTable];
        SetAssociatedObject(@selector(cc_observers), observers);
    }

    return observers;
}

- (CCObjectObserver *)observerForObject:(id)object
{
    CCObjectObserver *observer = [self.cc_observers objectForKey:object];

    if (!observer) {
        observer = [[CCObjectObserver alloc] initWithObject:object observer:self];
        [self.cc_observers setObject:observer forKey:object];
    }

    return observer;
}

@end
