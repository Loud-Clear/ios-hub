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

#import "RLMObject+ThreadSafety.h"
#import "CCSafeRLMObjectProxy.h"
#import <Realm/Realm.h>
#import <Realm/RLMRealm_Dynamic.h>

@implementation RLMObject (ThreadSafety)

- (instancetype)standaloneCopy
{
    return [(RLMObject *)[[self class] alloc] initWithValue:self];
}

- (instancetype)standaloneDeepCopy
{
    return [self copyWithBlock:^id(RLMObject *managedInstance) {
        return [managedInstance standaloneCopy];
    } deepCopyBlock:^id(RLMObject *managedInstance) {
        return [managedInstance standaloneDeepCopy];
    }];
}

- (instancetype)threadedSafeCopy
{
    return (id)[[CCSafeRLMObjectProxy alloc] initWithRLMObject:self];
}

- (instancetype)threadedSafeDeepCopy
{
    return [self copyWithBlock:^id(RLMObject *managedInstance) {
        return [managedInstance threadedSafeCopy];
    } deepCopyBlock:^id(RLMObject *managedInstance) {
        return [managedInstance threadedSafeDeepCopy];
    }];
}

- (instancetype)realmCopy
{
    if ([self isStandalone]) {
        id primaryKey = [self valueForKey:self.objectSchema.primaryKeyProperty.name];
        return [[RLMRealm defaultRealm] objectWithClassName:self.objectSchema.className forPrimaryKey:primaryKey];
    } else {
        return self;
    }
}

- (instancetype)copyWithBlock:(id(^)(RLMObject *managedInstance))copyBlock deepCopyBlock:(id(^)(RLMObject *managedInstance))deepBlock
{
    typeof(self) copy = copyBlock(self);

    if (deepBlock) {
        RLMObjectSchema *schema = self.objectSchema;
        [schema.properties enumerateObjectsUsingBlock:^(RLMProperty *prop, NSUInteger idx, BOOL *stop) {
            if ([self respondsToSelector:NSSelectorFromString(prop.name)]) {
                if (prop.type == RLMPropertyTypeArray) {
                    RLMArray<RLMObject *> *currentArray = [copy valueForKey:prop.name];
                    for (NSUInteger i = 0; i < [currentArray count]; i++) {
                        RLMObject *managed = [currentArray objectAtIndex:i];
                        [currentArray replaceObjectAtIndex:i withObject:deepBlock(managed)];
                    }
                }
                else if (prop.type == RLMPropertyTypeObject) {
                    RLMObject *managed = [self valueForKey:prop.name];
                    [copy setValue:deepBlock(managed) forKey:prop.name];
                }
            }
        }];
    }

    return copy;
}

+ (NSArray *)standaloneDeepCopyOf:(NSArray <RLMObject *>*)objects
{
    NSMutableArray *objectsCopy = [NSMutableArray new];
    for (RLMObject *object in objects) {
        [objectsCopy addObject:[object standaloneDeepCopy]];
    }
    return [objectsCopy mutableCopy];
}

- (BOOL)isThreadSafe
{
    return NO;
}

- (BOOL)isStandalone
{
    return self.realm == nil;
}

@end