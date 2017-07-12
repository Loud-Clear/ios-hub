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

#import <Realm/Realm.h>
#import "CCResults.h"

@class CCPersistentModel;
@class CCPersistentId;
@protocol CCDatabaseManagerDelegate;

extern NSString * const CCDatabaseManagerDidRecreateDatabaseNotification;
extern NSString * const CCDatabaseManagerDidDeleteSensibleDataNotification;

@interface CCDatabaseManager : NSObject

@property (nonatomic, weak) id<CCDatabaseManagerDelegate> delegate;

/**
 * We have separate databases per user
 * */
@property (nonatomic, strong, readonly) RLMRealm *currentDatabase;


@property (nonatomic, readonly) BOOL isFreshStart;

/**
 * Must be called after setting sessionManager
 * */
- (void)setupDatabase;

- (void)registerSensibleDataRemovalNotification:(NSString *)notification;

- (void)unregisterSensibleDataRemovalNotification:(NSString *)notification;

/**
 * Replaces all objects for given class with objects from array
 *
 * It deletes all objects which 'newObjects' array doesn't contain, then
 * update values of existing objects, and inserts missing.
 * */
- (void)replaceObjectsForClass:(Class)objectsClass with:(NSArray *)newObjects;

- (void)addOrUpdateObjects:(id)array andKeepStandalone:(BOOL)keepStandalone;

/**
 * Deletes all User-specific data (used on logout)
 * */
- (void)deleteSensibleData;

//-------------------------------------------------------------------------------------------
#pragma mark - PersistentId support
//-------------------------------------------------------------------------------------------

- (id)objectFromId:(CCPersistentId *)modelId;

- (CCResults *)objectsFromIds:(NSArray<CCPersistentId *> *)modelIds;

@end

@protocol CCDatabaseManagerDelegate <NSObject>

@optional
/**
 * You can return your profile id here. That means that database belong to current user.
 * After user logout happened, or logged in another user, databaseManager can delete data
 * associated with the user.
 * */
- (NSString *)databaseOwnerId;

/**
 * You can customize rules to delete sensibleData. By default, CCDatabaseManager checks that databaseOwnerId changed.
 * */
- (BOOL)shouldDeleteSensibleData;

/**
 * Return list of CCPersistentModel subclasses here. DatabaseManager will delete all entries of these classes
 * */
- (NSArray<Class> *)sensibleDataClasses;

/**
 * Customize deletion here. For example, you can delete specific objects, instead of all objects of
 * class (sensibleDataClasses case)
 * */
- (void)deleteSensibleData;

@end
