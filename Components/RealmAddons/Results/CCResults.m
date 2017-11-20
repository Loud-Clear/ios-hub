////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////#import "CCGameWeek.h"

#import <Realm/RLMRealm.h>
#import <Realm/RLMResults.h>
#import <objc/objc.h>
#import "CCResults.h"
#import "CCPersistentModel.h"
#import "Realm+Arrays.h"
#import "CCMacroses.h"

@implementation CCNotificationToken {
    RLMNotificationToken *_token;
}

- (instancetype)initWithRLMToken:(RLMNotificationToken *)token
{
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (void)stop
{
    [_token stop];
}

@end

@interface CCResults()

@property (nonatomic, strong) RLMResults *results;
@property (nonatomic, strong) NSComparator sortingComparator;
@property (nonatomic, strong) NSArray<CCPersistentModel *> *sortedObjects;

@end

@implementation CCResults {
    RLMNotificationToken *_sortedObjectsUpdateToken;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sortedObjects = @[];
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray<CCPersistentModel *> *)objects
{
    self = [super init];
    if (self) {
        self.sortedObjects = objects;
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray<CCPersistentModel *> *)objects realm:(RLMRealm *)realm
{
    NSMutableArray *objectIds = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    for (CCPersistentModel *model in objects) {
        [objectIds addObject:[model persistentId]];
    }
    return [self initWithObjectIds:objectIds realm:realm];
}

- (instancetype)initWithObjectIds:(NSArray<CCPersistentId *> *)objectIds realm:(RLMRealm *)realm
{
    self = [super init];
    if (self) {
        if (realm && [objectIds count] > 0) {
            CCPersistentId *firstId = [objectIds firstObject];
            self.results = [realm objects:firstId.className WithPersistentIds:objectIds];
        }
        self.sortingComparator = [self comparatorWithSortedIds:objectIds];
        [self buildSortedArray];
    }
    return self;
}

- (instancetype)initWithRLMResults:(RLMResults *)results
{
    self = [super init];
    if (self) {
        self.results = results;
    }
    return self;
}

- (instancetype)initWithRLMResults:(RLMResults *)results sortComparator:(NSComparator)comparator
{
    self = [super init];
    if (self) {
        self.results = results;
        self.sortingComparator = comparator;
        [self buildSortedArray];
    }
    return self;
}

- (instancetype)initWithObjectIds:(NSArray<CCPersistentId *> *)objectIds results:(RLMResults *)results
{
    self = [super init];
    if (self) {
        self.results = results;
        self.sortingComparator = [self comparatorWithSortedIds:objectIds];
        [self buildSortedArray];
    }
    return self;
}

- (void)dealloc
{
    [_sortedObjectsUpdateToken stop];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Collection Methods
//-------------------------------------------------------------------------------------------

- (id)objectAtIndex:(NSUInteger)index
{
    return self.sortedObjects ? self.sortedObjects[index] : self.results[index];
}

- (id)firstObject
{
    return self.sortedObjects ? [self.sortedObjects firstObject] : [self.results firstObject];
}

- (id)lastObject
{
    return self.sortedObjects ? [self.sortedObjects lastObject] : [self.results lastObject];
}

- (NSUInteger)indexOfObject:(id)object
{
    return self.sortedObjects ? [self.sortedObjects indexOfObject:object] : [self.results indexOfObject:object];
}

- (CCNotificationToken *)addNotificationBlock:(void (^)(CCResults<CCPersistentModel *> *results))block
{
    if (self.results) {
        NSComparator comparator = self.sortingComparator;
        RLMNotificationToken *token = [self.results addNotificationBlock:^(RLMResults *results, RLMCollectionChange *change, NSError *error) {
            CCResults *updatedResults = [[CCResults alloc] initWithRLMResults:results sortComparator:comparator];
            CCSafeCall(block, updatedResults);
        }];
        return [[CCNotificationToken alloc] initWithRLMToken:token];
    } else {
        return [CCNotificationToken new];
    }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer
                                    count:(NSUInteger)len
{
    if (self.sortedObjects) {
        return [self.sortedObjects countByEnumeratingWithState:state objects:buffer count:len];
    } else {
        return [self.results countByEnumeratingWithState:state objects:buffer count:len];
    };
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (NSUInteger)count
{
    return self.sortedObjects ? [self.sortedObjects count] : [self.results count];
}

- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    if (self.sortedObjects) {
        return [self.sortedObjects indexOfObjectPassingTest:predicate];
    } else {
        NSUInteger foundIndex = NSNotFound;
        NSUInteger index = 0;
        for (id object in self.results) {
            BOOL stop = NO;
            if (predicate(object, index, &stop)) {
                foundIndex = index;
                break;
            }
            if (stop) {
                break;
            }
            index += 1;
        }
        return foundIndex;
    }
}

- (NSArray *)allObjects
{
    return self.sortedObjects ?: [self.results allObjects];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Filters
//-------------------------------------------------------------------------------------------

- (CCResults *)objectsWithPredicate:(NSPredicate *)predicate
{
    if (self.results) {
        return [[CCResults alloc] initWithRLMResults:[self.results objectsWithPredicate:predicate]
                                      sortComparator:self.sortingComparator];
    } else {
        return [[CCResults alloc] initWithObjects:[self.sortedObjects filteredArrayUsingPredicate:predicate]];
    }
}

- (id)objectWithIdentifier:(id)identifier
{
    Class clazz = NSClassFromString(self.results.objectClassName);
    NSString *primaryKey = [clazz primaryKey];
    return [[self objectsWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", primaryKey, identifier]] firstObject];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private
//-------------------------------------------------------------------------------------------

- (void)buildSortedArray
{
    if (self.results) {
        self.sortedObjects = [self sortedFromResults:self.results];
        @weakify(self)
        _sortedObjectsUpdateToken = [self.results addNotificationBlock:^(RLMResults *results, RLMCollectionChange *change, NSError *error) {
            @strongify(self)
            if (self) {
                self.sortedObjects = [self sortedFromResults:results];
            }
        }];
    } else {
        self.sortedObjects = @[];
        _sortedObjectsUpdateToken = nil;
    }
}

- (NSArray *)sortedFromResults:(RLMResults *)results
{
    NSArray *array = [results allObjects];
    if (self.sortingComparator) {
        array = [array sortedArrayUsingComparator:self.sortingComparator];
    }
    return array;
}

- (NSComparator)comparatorWithSortedIds:(NSArray<CCPersistentId *> *)objectIds
{
    NSMutableOrderedSet *sortedIds = [[NSMutableOrderedSet alloc] initWithCapacity:[objectIds count]];
    for (CCPersistentId *persistentId in objectIds) {
        [sortedIds addObject:persistentId.primaryKeyValue];
    }

    return ^NSComparisonResult(CCPersistentModel *model1, CCPersistentModel *model2) {
        id id1 = [model1 valueForKey:[model1.class primaryKey]];
        id id2 = [model2 valueForKey:[model2.class primaryKey]];
        return [@([sortedIds indexOfObject:id1]) compare:@([sortedIds indexOfObject:id2])];
    };
}

@end
