//
//  CCDispatchQueue.h
//
//  Created by Ivan on 04.02.14.
//

#import <Foundation/Foundation.h>


@interface CCDispatchQueue : NSObject

- (instancetype) initWithQueue:(dispatch_queue_t)queue;
- (instancetype) initWithLabel:(NSString *)label attributes:(dispatch_queue_attr_t)attributes;
- (instancetype) initWithLabel:(NSString *)label;
+ (instancetype) mainQueue;
+ (instancetype) backgroundPriorityQueue;
+ (instancetype) lowPriorityQueue;
+ (instancetype) defaultPriorityQueue;
+ (instancetype) highPriorityQueue;

- (void) async:(dispatch_block_t)block;
- (void) after:(NSTimeInterval)interval async:(dispatch_block_t)block;
- (void) sync:(dispatch_block_t)block;

@property (nonatomic, readonly) dispatch_queue_t queue;

@end
