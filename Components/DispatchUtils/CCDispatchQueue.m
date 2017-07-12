//
//  CCDispatchQueue.m
//
//  Created by Ivan on 04.02.14.
//

#import "CCDispatchQueue.h"

@implementation CCDispatchQueue

- (id) init
{
    self = [self initWithLabel:nil];
    return self;
}

- (instancetype) initWithQueue:(dispatch_queue_t)queue
{
    if ((self = [super init])) {
        NSParameterAssert(queue);
        _queue = queue;
    }
    return self;
}

- (instancetype) initWithLabel:(NSString *)label attributes:(dispatch_queue_attr_t)attributes
{
    const char *cLabel = [label UTF8String];
    dispatch_queue_t queue = dispatch_queue_create(cLabel, 0);
    self = [self initWithQueue:queue];
    return self;
}

- (instancetype) initWithLabel:(NSString *)label
{
    self = [self initWithLabel:nil attributes:NULL];
    return self;
}

+ (instancetype) mainQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_main_queue()];
    });
    return dispatchQueue;
}

+ (instancetype) backgroundPriorityQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    });
    return dispatchQueue;
}

+ (instancetype) lowPriorityQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    });
    return dispatchQueue;
}

+ (instancetype) defaultPriorityQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    });
    return dispatchQueue;
}

+ (instancetype) highPriorityQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    });
    return dispatchQueue;
}

+ (instancetype) serialQueueWithName:(NSString *)name
{
    CCDispatchQueue *queue = [[CCDispatchQueue alloc] initWithLabel:name];
    return queue;
}

- (void) async:(dispatch_block_t)block
{
    dispatch_async(_queue, block);
}

- (void) after:(NSTimeInterval)interval async:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), _queue, block);
}

- (void) sync:(dispatch_block_t)block
{
    dispatch_sync(_queue, block);
}

@end
