//
//  CCDispatchGroup.m
//
//  Created by Aleksey Garbarev on 20.12.13.
//

#import "CCDispatchGroup.h"


@implementation CCDispatchGroup
{
    dispatch_group_t _group;
}

- (id)init
{
    self = [super init];
    if (self) {
        _group = dispatch_group_create();
    }
    return self;
}

- (void)enter
{
    dispatch_group_enter(_group);
}

- (void)enter:(NSUInteger)count
{
    for (NSUInteger i = 0; i < count; i++) {
        [self enter];
    }
}

- (void)leave
{
    dispatch_group_leave(_group);
}

- (void)notifyOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_group_notify(_group, queue, block);
}

- (void)notifyOnMainQueue:(dispatch_block_t)block
{
    dispatch_group_notify(_group, dispatch_get_main_queue(), block);
}

- (void)notifyOnMainQueueWithBlock:(dispatch_block_t)block
{
    [self notifyOnMainQueue:block];
}

@end
