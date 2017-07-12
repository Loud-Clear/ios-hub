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

#import "CCMapCollections.h"

@implementation NSArray (Map)

- (instancetype)arrayUsingMap:(id(^)(id object))mapBlock
{
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        id newObject = mapBlock(object);
        if (newObject) {
            [newArray addObject:newObject];
        }
    }
    return newArray;
}

@end

@implementation NSMutableArray (Map)

- (void)map:(id(^)(id object))mapBlock
{
    NSArray *newArray = [self arrayUsingMap:mapBlock];
    [self setArray:newArray];
}

@end

@implementation NSSet(Map)

- (instancetype)setUsingMap:(id(^)(id object))mapBlock
{
    NSMutableSet *newSet = [NSMutableSet setWithCapacity:self.count];
    for (id object in self) {
        id newObject = mapBlock(object);
        if (newObject) {
            [newSet addObject:newObject];
        }
    }
    return newSet;
}

@end

@implementation NSMutableSet(Map)

- (void)map:(id(^)(id object))mapBlock
{
    NSSet *set = [self setUsingMap:mapBlock];
    [self setSet:set];
}

@end

@implementation NSMutableDictionary (Map)

- (void)mapObjects:(id(^)(id key, id object))mapBlock
{
    for (id key in [self allKeys]) {
        id currentObject = self[key];
        id changedObject = mapBlock(key, currentObject);
        self[key] = changedObject;
    }
}

- (void)mapKeys:(id(^)(id key, id object))mapBlock
{
    NSArray *oldKeys = [[self allKeys] copy];
    for (id oldKey in oldKeys) {
        id currentObject = self[oldKey];
        id newKey = mapBlock(oldKey, currentObject);
        [self removeObjectForKey:oldKey];
        self[newKey] = currentObject;
    }
}

@end

@implementation NSDictionary (Map)

- (NSDictionary *)dictionaryUsingObjectMap:(id(^)(id key, id object))mapBlock
{
    NSMutableDictionary *mutableCopy = [self mutableCopy];
    [mutableCopy mapObjects:mapBlock];
    return mutableCopy;
}

- (NSDictionary *)dictionaryUsingKeyMap:(id(^)(id key, id object))mapBlock
{
    NSMutableDictionary *mutableCopy = [self mutableCopy];
    [mutableCopy mapKeys:mapBlock];
    return mutableCopy;
}

@end
