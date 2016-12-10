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

#import <Foundation/Foundation.h>
#import "CCPersistentId.h"

@class RLMRealm;
@class RLMResults;

@interface CCNotificationToken : NSObject

- (void)stop;

@end

@interface CCResults <ObjectType : CCPersistentModel *> : NSObject <NSFastEnumeration>

//-------------------------------------------------------------------------------------------
#pragma mark - Creation
//-------------------------------------------------------------------------------------------

- (instancetype)initWithObjects:(NSArray<ObjectType> *)objects realm:(RLMRealm *)realm;
- (instancetype)initWithObjectIds:(NSArray<CCPersistentId *> *)objectIds realm:(RLMRealm *)realm;
- (instancetype)initWithRLMResults:(RLMResults *)results;
- (instancetype)initWithRLMResults:(RLMResults *)results sortComparator:(NSComparator)comparator;
- (instancetype)initWithObjectIds:(NSArray<CCPersistentId *> *)objectIds results:(RLMResults *)results;

//-------------------------------------------------------------------------------------------
#pragma mark - Collection
//-------------------------------------------------------------------------------------------

@property (nonatomic, readonly, assign) NSUInteger count;

- (ObjectType)objectAtIndex:(NSUInteger)index;

- (ObjectType)firstObject;

- (ObjectType)lastObject;

- (NSUInteger)indexOfObject:(ObjectType)object;

- (id)objectAtIndexedSubscript:(NSUInteger)index;

- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (NSArray<ObjectType> *)allObjects;

- (id)objectWithIdentifier:(id)identifier;

//-------------------------------------------------------------------------------------------
#pragma mark - Notifications
//-------------------------------------------------------------------------------------------

- (CCNotificationToken *)addNotificationBlock:(void (^)(CCResults<ObjectType> *results))block;

//-------------------------------------------------------------------------------------------
#pragma mark - CCResults
//-------------------------------------------------------------------------------------------

- (CCResults *)objectsWithPredicate:(NSPredicate *)predicate;

@end
