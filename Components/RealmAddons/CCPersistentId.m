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

#import <Realm/RLMResults.h>
#import "CCPersistentId.h"
#import "CCPersistentModel.h"
#import "RLMRealm_Dynamic.h"


@implementation CCPersistentId

- (instancetype)initWithModel:(CCPersistentModel *)model
{
    self = [super init];
    if (self) {
        _className = [[model objectSchema] className];
        _primaryKeyValue = [model valueForKey:[self primaryKey]];
    }
    return self;
}

- (NSString *)primaryKey
{
    return [NSClassFromString(self.className) primaryKey];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"%@.%@ = %@", [self className], [self primaryKey], [self primaryKeyValue]];
    [description appendString:@">"];
    return description;
}

@end

@implementation RLMRealm (ССPersistentId)

- (RLMResults *)objects:(NSString *)className WithPersistentIds:(NSArray<CCPersistentId *> *)modelIds
{
    NSString *primaryKey = [NSClassFromString(className) primaryKey];
    NSMutableArray *primaryKeys = [[NSMutableArray alloc] initWithCapacity:[modelIds count]];
    for (CCPersistentId *identifier in modelIds) {
        [primaryKeys addObject:identifier.primaryKeyValue];
    }
    return [self objects:className where:@"%K IN %@", primaryKey, primaryKeys];
}

@end

@implementation NSArray (ССPersistentId)

- (NSArray<CCPersistentId *> *)persistentId
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (CCPersistentModel *model in self) {
        [result addObject:[model persistentId]];
    }
    return result;
}

@end

@implementation CCPersistentModel (ССPersistentId)

- (CCPersistentId *)persistentId
{
    return [[CCPersistentId alloc] initWithModel:self];
}

@end
