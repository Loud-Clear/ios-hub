//
//  CCDispatchQueue.h
//
//  Created by Ivan on 04.02.14.
//

@import Foundation;


@interface CCDispatchQueue : NSObject

@property (nonatomic, readonly) dispatch_queue_t queue;

- (instancetype)initWithQueue:(dispatch_queue_t)queue;
- (instancetype)initWithLabel:(NSString *)label attributes:(dispatch_queue_attr_t)attributes;
- (instancetype)initSerialWithLabel:(NSString *)label;
+ (instancetype)concurrentQueueWithLabel:(NSString *)label;
+ (instancetype)concurrentQueueWithLabel:(NSString *)label priority:(dispatch_qos_class_t)qosClass;
+ (instancetype)serialQueueWithLabel:(NSString *)label;
+ (instancetype)serialQueueWithLabel:(NSString *)label priority:(dispatch_qos_class_t)qosClass;

+ (instancetype)mainQueue;
+ (instancetype)backgroundPrioritySerialQueue;
+ (instancetype)lowPrioritySerialQueue;
+ (instancetype)defaultPrioritySerialQueue;
+ (instancetype)highPrioritySerialQueue;
+ (instancetype)highestPrioritySerialQueue;

+ (instancetype)backgroundPriorityConcurrentQueue;
+ (instancetype)lowPriorityConcurrentQueue;
+ (instancetype)defaultPriorityConcurrentQueue;
+ (instancetype)highPriorityConcurrentQueue;

- (void)async:(dispatch_block_t)block;
- (void)after:(NSTimeInterval)interval async:(dispatch_block_t)block;
- (void)sync:(dispatch_block_t)block;

// Deprecated methods:
- (instancetype)initWithLabel:(NSString *)label __deprecated_msg("use initSerialWithLabel");
+ (instancetype)backgroundPriorityQueue __deprecated_msg("use backgroundPrioritySerialQueue or backgroundPriorityConcurrentQueue");
+ (instancetype)lowPriorityQueue __deprecated_msg("use lowPrioritySerialQueue or lowPriorityConcurrentQueue");
+ (instancetype)defaultPriorityQueue __deprecated_msg("use defaultPrioritySerialQueue or defaultPriorityConcurrentQueue");
+ (instancetype)highPriorityQueue __deprecated_msg("use highPrioritySerialQueue or highPriorityConcurrentQueue");

@end
