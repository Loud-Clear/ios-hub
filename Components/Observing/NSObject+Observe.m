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
#import "NSObject+Observe.h"
#import "CCObjectObserver.h"
#import "CCMacroses.h"

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

@end


@interface NSObject (Observe)

@property (nonatomic, weak) CCObjectObserver *cc_observer;

@end


@implementation NSObject (Observe)

- (void)observe:(id)object key:(NSString *)key action:(SEL)action
{
    [self.cc_observer unobserveKeys:@[key]];

    if (!self.cc_observer) {
        self.cc_observer = [[CCObjectObserver alloc] initWithObject:object observer:self];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)setCc_observer:(CCObjectObserver *)cc_observer
{
    SetAssociatedObject(@selector(cc_observer), cc_observer);
}

- (CCObjectObserver *)cc_observer
{
    return GetAssociatedObject(@selector(cc_observer));
}

@end
