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

#import <Foundation/Foundation.h>

@interface NSObject (CCObserve)

/// Will subscribe to changes of specified key, and automatically unsubscribe when self dies.
- (void)observe:(id)object key:(NSString *)key action:(SEL)action;
- (void)observe:(id)object key:(NSString *)key block:(dispatch_block_t)block;
- (void)unobserve:(id)object key:(NSString *)key;

@end
