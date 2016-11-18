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
#import "Realm+Arrays.h"

NSMutableSet *DTPrimaryKeysFromCollection(id<NSFastEnumeration> collection, NSString *primaryKey)
{
    NSUInteger count = 0;
    if ([(NSObject *)collection respondsToSelector:@selector(count)]) {
        count = [(NSArray *)collection count];
    }

    NSMutableSet *primaryKeys = [[NSMutableSet alloc] initWithCapacity:count];

    for (id item in collection) {
        [primaryKeys addObject:[item valueForKey:primaryKey]];
    }

    return primaryKeys;
}

@implementation RLMResults (Array)

- (NSArray *)allObjects
{
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:self.count];

    for (id object in self) {
        [objects addObject:object];
    }

    return objects;
}

- (NSMutableSet *)primaryKeysSet
{
    Class itemClass = NSClassFromString(self.objectClassName);
    NSString *idKey = [itemClass primaryKey];

    return DTPrimaryKeysFromCollection(self, idKey);
}

@end

@implementation RLMArray (Array)

- (NSArray *)allObjects
{
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:self.count];

    for (id object in self) {
        [objects addObject:object];
    }

    return objects;
}

- (NSMutableSet *)primaryKeysSet
{
    Class itemClass = NSClassFromString(self.objectClassName);
    NSString *idKey = [itemClass primaryKey];

    return DTPrimaryKeysFromCollection(self, idKey);
}

+ (id)arrayWithArray:(NSArray *)array objectsClass:(Class)clazz
{
    RLMArray *result = [[RLMArray alloc] initWithObjectClassName:NSStringFromClass(clazz)];
    for (id item in array) {
        [result addObject:item];
    }
    return result;
}

@end
