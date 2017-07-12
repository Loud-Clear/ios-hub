////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Realm/RLMObject.h>

@interface RLMObject (ThreadSafety)

- (instancetype)standaloneCopy;

- (instancetype)standaloneDeepCopy;

- (instancetype)threadedSafeCopy;

- (instancetype)threadedSafeDeepCopy;

+ (NSArray *)standaloneDeepCopyOf:(NSArray <RLMObject *>*)objects;

- (BOOL)isThreadSafe;

- (BOOL)isStandalone;

/**
 * Restore original (Thread-dependent and Realm-connected) object back
 * */
- (instancetype)realmCopy;

@end
