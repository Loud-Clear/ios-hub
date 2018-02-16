////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@import Foundation;


@interface NSObject (ChangeValueForKey)

- (void)cc_changeValueForKey:(NSString *)key block:(dispatch_block_t)block;
- (void)cc_changeValueForKeys:(NSArray<NSString *> *)keys block:(dispatch_block_t)block;

@end
