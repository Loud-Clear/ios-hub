////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <objc/runtime.h>
#import <Typhoon/NSObject+DeallocNotification.h>
#import "NSObject+Observe.h"
#import "CCObjectObserver.h"
#import "CCMacroses.h"
#import "TPDWeakProxy.h"
#import "Typhoon/NSObject+DeallocNotification.h"


@interface NSObject (CCObserver)

@property (nonatomic, readonly) NSMapTable<NSValue *, id> *cc_observers;

@end


@implementation NSObject (CCObserve)

- (void)observe:(id)object key:(NSString *)key action:(SEL)action
{
    CCObjectObserver *observer = [self observerForObject:observer];
    [observer unobserveKeys:@[key]];
    [observer observeKeys:@[key] withAction:action];
}

- (void)observe:(id)object key:(NSString *)key block:(dispatch_block_t)block
{
    CCObjectObserver *observer = [self observerForObject:observer];
    [observer unobserveKeys:@[key]];
    [observer observeKeys:@[key] withBlock:block];
}

- (void)unobserve:(id)object key:(NSString *)key
{
    CCObjectObserver *observer = [self.cc_observers objectForKey:object];

    if (!observer) {
        return;
    }

    [observer unobserve:object key:key];

    if ([observer observationsCount] == 0) {
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
