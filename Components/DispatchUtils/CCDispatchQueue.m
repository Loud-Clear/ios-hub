//
//  CCDispatchQueue.m
//
//  Created by Ivan on 04.02.14.
//

#import "CCDispatchQueue.h"


@implementation CCDispatchQueue

- (id)init
{
    self = [self initSerialWithLabel:nil];
    return self;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue
{
    if ((self = [super init])) {
        NSParameterAssert(queue);
        _queue = queue;
    }
    return self;
}

- (instancetype)initWithLabel:(NSString *)label attributes:(dispatch_queue_attr_t)attributes
{
    const char *cLabel = [label UTF8String];
    dispatch_queue_t queue = dispatch_queue_create(cLabel, attributes);
    self = [self initWithQueue:queue];
    return self;
}

- (instancetype)initSerialWithLabel:(NSString *)label
{
    self = [self initWithLabel:nil attributes:DISPATCH_QUEUE_SERIAL];
    return self;
}

+ (instancetype)serialQueueWithLabel:(NSString *)label priority:(dispatch_qos_class_t)qosClass
{
    return [[self alloc] initWithLabel:label attributes:dispatch_queue_attr_make_with_qos_class(
            DISPATCH_QUEUE_SERIAL,
            qosClass,
            0
    )];
}

+ (instancetype)concurrentQueueWithLabel:(NSString *)label
{
    return nil;
}

+ (instancetype)concurrentQueueWithLabel:(NSString *)label priority:(dispatch_qos_class_t)qosClass
{
    return [[self alloc] initWithLabel:label attributes:dispatch_queue_attr_make_with_qos_class(
            DISPATCH_QUEUE_CONCURRENT,
            qosClass,
            0
    )];
}

+ (instancetype)mainQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_main_queue()];
    });
    return dispatchQueue;
}

+ (instancetype)backgroundPriorityConcurrentQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    });
    return dispatchQueue;
}

+ (instancetype)lowPriorityConcurrentQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    });
    return dispatchQueue;
}

+ (instancetype)defaultPriorityConcurrentQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    });
    return dispatchQueue;
}

+ (instancetype)highPriorityConcurrentQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [[self alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    });
    return dispatchQueue;
}

+ (instancetype)backgroundPrioritySerialQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [self serialQueueWithLabel:nil priority:QOS_CLASS_BACKGROUND];
    });
    return dispatchQueue;
}

+ (instancetype)lowPrioritySerialQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [self serialQueueWithLabel:nil priority:QOS_CLASS_UTILITY];
    });
    return dispatchQueue;
}

+ (instancetype)defaultPrioritySerialQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [self serialQueueWithLabel:nil priority:QOS_CLASS_DEFAULT];
    });
    return dispatchQueue;
}

+ (instancetype)highPrioritySerialQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [self serialQueueWithLabel:nil priority:QOS_CLASS_USER_INITIATED];
    });
    return dispatchQueue;
}

+ (instancetype)highestPrioritySerialQueue
{
    static CCDispatchQueue *dispatchQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchQueue = [self serialQueueWithLabel:nil priority:QOS_CLASS_USER_INTERACTIVE];
    });
    return dispatchQueue;
}

+ (instancetype)serialQueueWithLabel:(NSString *)label
{
    CCDispatchQueue *queue = [[CCDispatchQueue alloc] initSerialWithLabel:label];
    return queue;
}

- (void)async:(dispatch_block_t)block
{
    dispatch_async(_queue, block);
}

- (void)after:(NSTimeInterval)interval async:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (interval * NSEC_PER_SEC)), _queue, block);
}

- (void)sync:(dispatch_block_t)block
{
    dispatch_sync(_queue, block);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Deprecated methods
//-------------------------------------------------------------------------------------------

- (instancetype)initWithLabel:(NSString *)label
{
    return [self initSerialWithLabel:label];
}

+ (instancetype)backgroundPriorityQueue
{
    return [self backgroundPriorityConcurrentQueue];
}

+ (instancetype)lowPriorityQueue
{
    return [self lowPriorityConcurrentQueue];
}

+ (instancetype)defaultPriorityQueue
{
    return [self defaultPriorityConcurrentQueue];
}

+ (instancetype)highPriorityQueue
{
    return [self highPriorityConcurrentQueue];
}

@end
