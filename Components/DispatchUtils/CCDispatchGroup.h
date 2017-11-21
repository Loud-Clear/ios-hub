//
//  CCDispatchGroup.h
//
//  Created by Aleksey Garbarev on 20.12.13.
//

@import Foundation;


@interface CCDispatchGroup : NSObject

- (void)enter;
- (void)enter:(NSUInteger)count;
- (void)leave;

- (void)notifyOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block;
- (void)notifyOnMainQueue:(dispatch_block_t)block;

- (void)notifyOnMainQueueWithBlock:(dispatch_block_t)block __deprecated_msg("use notifyOnMainQueue");

@end
