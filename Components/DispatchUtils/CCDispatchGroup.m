//
//  CCDispatchGroup.m
//
//  Created by Aleksey Garbarev on 20.12.13.
//

#import "CCDispatchGroup.h"

@implementation CCDispatchGroup {
    dispatch_group_t group;
    NSInteger counter;
}

- (id) init {
    self = [super init];
    if (self) {
        counter = 0;
        group = dispatch_group_create();
    }
    return self;
}

- (void) enter
{
    counter++;
    dispatch_group_enter(group);
}

- (void) leave
{
    if (counter > 0) {
        counter--;
        dispatch_group_leave(group);
    }
}

- (void) leaveAll
{
    while (counter != 0) {
        [self leave];
    }
}

- (void) notifyOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_group_notify(group, queue, block);
}

- (void) notifyOnBackgrounQueueWithBlock:(dispatch_block_t)block
{
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (void) notifyOnMainQueueWithBlock:(dispatch_block_t)block
{
    dispatch_group_notify(group, dispatch_get_main_queue(), block);
}

@end
