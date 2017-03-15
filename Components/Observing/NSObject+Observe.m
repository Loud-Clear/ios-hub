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

@interface CCObjectObserver (SelfLink)
@property (nonatomic) id cc_selfLink;

@end

@implementation CCObjectObserver (SelfLink)

- (void)setCc_selfLink:(id)selfLink
{
    SetAssociatedObject(@selector(cc_selfLink), selfLink);
}

- (id)cc_selfLink
{
    return GetAssociatedObject(@selector(cc_selfLink));
}

- (void)liveUntilObjectDies:(id)object
{
    self.cc_selfLink = self;

    @weakify(self);
    [object setDeallocNotificationInBlock:^{
        @strongify(self);
        [self stopAndInvalidate];
        self.cc_selfLink = nil;
    }];
}

@end


@interface NSObject (CCObserver)

@property (nonatomic) CCObjectObserver *cc_observer;

@end


@implementation NSObject (CCObserve)

- (void)observe:(id)object key:(NSString *)key action:(SEL)action
{
    [self.cc_observer unobserveKeys:@[key]];

    if (!self.cc_observer) {
        CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:object observer:self];
        [observer liveUntilObjectDies:self];
        self.cc_observer = (id)[[TPDWeakProxy alloc] initWithObject:observer];
    }

    [self.cc_observer observeKeys:@[key] withAction:action];
}

- (void)observe:(id)object key:(NSString *)key block:(dispatch_block_t)block
{
    [self.cc_observer unobserveKeys:@[key]];

    if (!self.cc_observer) {
        CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:object observer:self];
        [observer liveUntilObjectDies:self];
        self.cc_observer = (id)[[TPDWeakProxy alloc] initWithObject:observer];
    }

    [self.cc_observer observeKeys:@[key] withBlock:block];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)setCc_observer:(CCObjectObserver *)observer
{
    SetAssociatedObject(@selector(cc_observer), observer);
}

- (CCObjectObserver *)cc_observer
{
    return GetAssociatedObject(@selector(cc_observer));
}

@end
