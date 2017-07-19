////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface NSObject (CCObserve)

/// Will subscribe to changes of specified key, and automatically unsubscribe when self dies.
- (void)observe:(id)object key:(NSString *)key action:(SEL)action;
- (void)observe:(id)object keys:(NSArray<NSString *> *)keys action:(SEL)action;
- (void)observe:(id)object key:(NSString *)key block:(dispatch_block_t)block;
- (void)observe:(id)object keys:(NSArray<NSString *> *)keys block:(dispatch_block_t)block;

- (void)unobserve:(id)object key:(NSString *)key;
- (void)unobserve:(id)object;
- (void)unobserveKey:(NSString *)key;

@end
