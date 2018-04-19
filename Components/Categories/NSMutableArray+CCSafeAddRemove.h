////////////////////////////////////////////////////////////////////////////////
//
//  Fernwood
//  Created by ivan at 12.04.2018.
//
//  Copyright 2018 Loud & Clear Pty Ltd Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@interface NSMutableArray (CCSafeAddRemove)

- (void)cc_safeAddObject:(id)object;
- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index;

@end
