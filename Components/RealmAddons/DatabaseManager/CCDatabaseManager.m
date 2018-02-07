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

#import <Realm/RLMRealm.h>
#import <Realm/RLMRealmConfiguration.h>
#import <Realm/RLMRealm_Dynamic.h>
#import "RLMRealm+NestedTransactions.h"

#import "CCDatabaseManager.h"
#import "CCNotificationUtils.h"
#import "CCPersistentModel.h"
#import "CCPersistentId.h"
#import <objc/runtime.h>

#import "CCMacroses.h"



@interface CCDatabaseOwner : RLMObject
@property NSString *ownerIdentifier;
@end
@implementation CCDatabaseOwner
+ (NSString *)primaryKey
{
    return @"ownerIdentifier";
}
@end

NSString * const CCDatabaseManagerDidRecreateDatabaseNotification = @"CCDatabaseManagerDidRecreateDatabaseNotification";
NSString * const CCDatabaseManagerDidDeleteSensibleDataNotification = @"CCDatabaseManagerDidDeleteSensibleDataNotification";


@implementation CCDatabaseManager {
    RLMRealmConfiguration *_currentConfiguration;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------

+ (void)load
{
    [self swizzleAddOrUpdateObject];
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Instance Methods
//-------------------------------------------------------------------------------------------

- (void)registerSensibleDataRemovalNotification:(NSString *)notification
{
    [self registerForNotification:notification selector:@selector(reconfigureDatabaseForCurrentOwner)];
}

- (void)unregisterSensibleDataRemovalNotification:(NSString *)notification
{
    [self unregisterForNotification:notification];
}

- (void)replaceObjectsForClass:(Class)objectsClass with:(NSArray *)newObjects
{
    RLMRealm *database = self.currentDatabase;

    NSSet *idsToDelete = [self primaryKeysToDeleteWithNewObjects:newObjects modelClass:objectsClass];

    [database transactionIfNeeded:^{
        NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"%K IN %@", [objectsClass primaryKey], idsToDelete];
        RLMResults *objectsToDelete = [objectsClass objectsInRealm:database withPredicate:deletePredicate];
        [database deleteObjects:objectsToDelete];
        [database addOrUpdateObjects:newObjects];
    }];
}

- (void)addOrUpdateObjects:(id)array andKeepStandalone:(BOOL)keepStandalone
{
    if (!keepStandalone) {
        [self.currentDatabase addOrUpdateObjects:array];
    } else {
        for (RLMObject *object in array) {
            RLMObject *copyOfStandalone = [object standaloneDeepCopy];
            [self.currentDatabase addOrUpdateObject:copyOfStandalone];
        }
    }
}

- (RLMRealm *)currentDatabase
{
    if (!_currentConfiguration) {
        [self setupDatabase];
    }
    return [RLMRealm realmWithConfiguration:_currentConfiguration error:nil];
}

- (void)setupDatabase
{
    _currentConfiguration = [RLMRealmConfiguration new];
    _currentConfiguration.fileURL = [self databasePath];
    _currentConfiguration.deleteRealmIfMigrationNeeded = NO;

    DDLogInfo(@"Will setup database at path: %@", [_currentConfiguration.fileURL path]);

    if (![[NSFileManager defaultManager] fileExistsAtPath:_currentConfiguration.fileURL.path]) {
        _isFreshStart = YES;
    } else {
        @try {
            [RLMRealm realmWithConfiguration:_currentConfiguration error:nil];
        } @catch (id exception) {
            _isFreshStart = YES;

            DDLogVerbose(@"Database needs migration because: %@", exception);
            NSString *databasePath = [_currentConfiguration.fileURL path];
            [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[databasePath stringByAppendingPathExtension:@"lock"] error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[databasePath stringByAppendingPathExtension:@"management"] error:nil];

            DDLogVerbose(@"Saving new owner for clean database");
            [self saveDatabaseOwner];
            
            [NSNotificationCenter postNotificationToMainThread:CCDatabaseManagerDidRecreateDatabaseNotification];
        }
    }

    //No migrations, since we not store data but cache (easy to get all again)

    [self deleteSensibleDataIfNeeded];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private
//-------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------
#pragma mark - Sensible data removal logic
//-------------------------------------------------------------------------------------------

- (void)deleteSensibleDataIfNeeded
{
    if ([self shouldDeleteSensibleData]) {
        [self deleteSensibleData];
    }
}

- (NSString *)databaseOwnerId
{
    if ([self.delegate respondsToSelector:@selector(databaseOwnerId)]) {
        return [self.delegate databaseOwnerId];
    } else {
        return nil;
    }
}

- (BOOL)shouldDeleteSensibleData
{
    if ([self.delegate respondsToSelector:@selector(shouldDeleteSensibleData)]) {
        return [self.delegate shouldDeleteSensibleData];
    }
    else if ([self.delegate respondsToSelector:@selector(databaseOwnerId)]) {
        RLMResults<CCDatabaseOwner *> *allOwners = [CCDatabaseOwner allObjectsInRealm:self.currentDatabase];
        BOOL isDatabaseCorrupted = ([allOwners count] > 1);
        BOOL isUserLoggedIn = [self databaseOwnerId] != nil;

        if (!isDatabaseCorrupted && isUserLoggedIn) {
            NSString *currentId = [self databaseOwnerId];
            CCDatabaseOwner *owner = [allOwners firstObject];
            if (![owner.ownerIdentifier isEqualToString:currentId]) {
                DDLogInfo(@"Will delete sensible data, because ownerId changed. (%@ -> %@)", owner.ownerIdentifier, currentId);
                return YES;
            }
        } else {
            //Database corrupted or user signed out
            if (isUserLoggedIn) {
                DDLogInfo(@"Will delete sensible data, because more than one database owner: %@", allOwners);
            } else {
                DDLogInfo(@"Will delete sensible data, because logout");
            }
            return YES;
        }
        return NO;
    } else {
        return NO;
    }

    //Never delete persistent data..
    return NO;
}

- (void)reconfigureDatabaseForCurrentOwner
{
    [self deleteSensibleDataIfNeeded];

    [self saveDatabaseOwner];
}

- (void)saveDatabaseOwner
{
    if ([self databaseOwnerId]) {
        [self.currentDatabase transactionIfNeeded:^{
            CCDatabaseOwner *owner = [CCDatabaseOwner new];
            owner.ownerIdentifier = [self databaseOwnerId];
            [self.currentDatabase addOrUpdateObject:owner];
        }];
    }
}

- (void)deleteSensibleData
{
    //Delete all objects for specified classes
    if ([self.delegate respondsToSelector:@selector(sensibleDataClasses)]) {
        NSArray *sensibleDataClasses = [self.delegate sensibleDataClasses];

        sensibleDataClasses = [sensibleDataClasses arrayByAddingObject:[CCDatabaseOwner class]];

        [self.currentDatabase transactionIfNeeded:^{
            DDLogVerbose(@"Deleting Sensible Data...");
            for (Class modelClass in sensibleDataClasses) {
                NSString *modelClassName = NSStringFromClass(modelClass);
                RLMResults *allObjects = [self.currentDatabase allObjects:modelClassName];
                DDLogInfo(@"%d %@ deleted", (int)[allObjects count], modelClassName);
                [self.currentDatabase deleteObjects:allObjects];
            }
        }];
    }

    //Custom delete action from delegate
    if ([self.delegate respondsToSelector:@selector(deleteSensibleData)]) {
        [self.delegate deleteSensibleData];
    }

    [NSNotificationCenter postNotificationToMainThread:CCDatabaseManagerDidDeleteSensibleDataNotification];
}

- (id)objectFromId:(CCPersistentId *)modelId
{
    if (!modelId) {
        return nil;
    } else {
        return [self.currentDatabase objectWithClassName:modelId.className forPrimaryKey:modelId.primaryKeyValue];
    }
}

- (CCResults *)objectsFromIds:(NSArray<CCPersistentId *> *)modelIds
{
    return [[CCResults alloc] initWithObjectIds:modelIds realm:self.currentDatabase];
}


- (NSURL *)databasePath
{
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *databaseDir = [libraryDirectory stringByAppendingPathComponent:@"Database"];
    [[NSFileManager defaultManager] createDirectoryAtPath:databaseDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [[databaseDir stringByAppendingPathComponent:@"Database"] stringByAppendingPathExtension:@"realm"];
    return [NSURL fileURLWithPath:path];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Utils
//-------------------------------------------------------------------------------------------

- (NSSet *)primaryKeysToDeleteWithNewObjects:(NSArray *)newObjects modelClass:(Class)modelClass
{
    // We want to delete all objects from database which is not inside new objects array
    NSString *className = NSStringFromClass(modelClass);

    RLMResults *currentObjects = [self.currentDatabase allObjects:className];
    NSMutableSet *currentObjectIds = [self primaryKeysFromResults:currentObjects];

    NSSet *newObjectsIds = [self primaryKeysFromArray:newObjects primaryKey:[modelClass primaryKey]];

    [currentObjectIds minusSet:newObjectsIds];

    return currentObjectIds;
}

- (NSMutableSet *)primaryKeysFromResults:(RLMResults *)results
{
    NSMutableSet *primaryKeys = [[NSMutableSet alloc] initWithCapacity:results.count];

    Class itemClass = NSClassFromString(results.objectClassName);
    NSString *idKey = [itemClass primaryKey];

    for (id item in results) {
        [primaryKeys addObject:[item valueForKey:idKey]];
    }

    return primaryKeys;
}

- (NSMutableSet *)primaryKeysFromArray:(NSArray *)objects primaryKey:(NSString *)primaryKey
{
    NSMutableSet *primaryKeys = [NSMutableSet new];
    for (id object in objects) {
        [primaryKeys addObject:[object valueForKey:primaryKey]];
    }
    return primaryKeys;
}

//-------------------------------------------------------------------------------------------
#pragma mark - RLM Swizzling - Before Add OR Update callbacks
//-------------------------------------------------------------------------------------------

void(*CCAddOrUpdateObject_Original)(id, SEL, id);

void CCAddOrUpdateObject(id target, SEL sel, id object)
{
    if ([object isKindOfClass:[CCPersistentModel class]]) {
        [(CCPersistentModel *)object beforeAddOrUpdate:target];
    }

    CCAddOrUpdateObject_Original(target, sel, object);
}

+ (void)swizzleAddOrUpdateObject
{
    Method originalMethod = class_getInstanceMethod([RLMRealm class], @selector(addOrUpdateObject:));

    CCAddOrUpdateObject_Original = (void (*)(id, SEL, id))method_getImplementation(originalMethod);

    method_setImplementation(originalMethod, (IMP)CCAddOrUpdateObject);
}

@end
