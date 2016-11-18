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
#import "DTPersistentId.h"
#import "DTPersistentModel.h"
#import "RLMRealm_Dynamic.h"


@implementation DTPersistentId

- (instancetype)initWithModel:(DTPersistentModel *)model
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

@implementation RLMRealm (DTPersistentId)

- (RLMResults *)objects:(NSString *)className WithPersistentIds:(NSArray<DTPersistentId *> *)modelIds
{
    NSString *primaryKey = [NSClassFromString(className) primaryKey];
    NSMutableArray *primaryKeys = [[NSMutableArray alloc] initWithCapacity:[modelIds count]];
    for (DTPersistentId *identifier in modelIds) {
        [primaryKeys addObject:identifier.primaryKeyValue];
    }
    return [self objects:className where:@"%K IN %@", primaryKey, primaryKeys];
}

@end

@implementation NSArray (DTPersistentId)

- (NSArray<DTPersistentId *> *)persistentId
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (DTPersistentModel *model in self) {
        [result addObject:[model persistentId]];
    }
    return result;
}

@end

@implementation DTPersistentModel (DTPersistentId)

- (DTPersistentId *)persistentId
{
    return [[DTPersistentId alloc] initWithModel:self];
}

@end