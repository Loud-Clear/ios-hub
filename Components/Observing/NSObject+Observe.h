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

@interface NSObject (Observe)

/// Will subscribe to changes of specified key, and automatically unsubscribe when self dies.
// TODO: write detailed tests for this magic.
- (void)observe:(id)object key:(NSString *)key action:(SEL)action;

@end
