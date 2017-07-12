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

#import <TyphoonRestClient/TRCUtils.h>
#import <TyphoonRestClient/TyphoonRestClientErrors.h>
#import "CCPersistentModelValueTransformer.h"
#import "CCDatabaseManager.h"
#import "RLMCollection.h"
#import "RLMObject.h"
#import "RLMRealm.h"
#import "RLMRealm+NestedTransactions.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "CCRestClient.h"


@implementation CCPersistentModelValueTransformer
{
    Class _modelClass;
    NSString *_modelPrimaryKey;
    CCDatabaseManager *_databaseManager;

    BOOL _isStringPrimaryKey;
}

+ (NSDictionary *)tagsForModelClasses
{
    return @{};
}

+ (void)registerWithRestClient:(CCRestClient *)restClient
{
    NSDictionary *tagsForModelClasses = [self tagsForModelClasses];

    [tagsForModelClasses enumerateKeysAndObjectsUsingBlock:^(NSString *tag, Class modelClass, BOOL *stop) {
        CCPersistentModelValueTransformer *transformer =
                [[self alloc] initWithModelClass:modelClass];

        [restClient registerValueTransformer:transformer forTag:tag];
    }];
}

- (instancetype)initWithModelClass:(Class)modelClass
{
    self = [super init];
    if (self) {
        _modelClass = modelClass;
        _modelPrimaryKey = [_modelClass primaryKey];

        _isStringPrimaryKey = NO;

        TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyNamed:@"_modelPrimaryKey" inClass:_modelClass];

        //Pointer to char
        if (type.isPointer &&  strcmp(type.encodedType, @encode(char)) == 0) {
            _isStringPrimaryKey = YES;
        } else if (!type.isPrimitive && [type.typeBeingDescribed isEqual:[NSString class]]) {
            _isStringPrimaryKey = YES;
        }

    }
    return self;
}

- (CCDatabaseManager *)databaseManager
{
    if (!_databaseManager) {
        _databaseManager = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:[CCDatabaseManager class]];
    }
    return _databaseManager;
}

+ (instancetype)transformerWithClass:(Class)modelClass
{
    return [[self alloc] initWithModelClass:modelClass];
}

- (id)objectFromResponseValue:(id)primaryKey error:(NSError **)error
{
    primaryKey = [self convertedResponseValue:primaryKey];

    if ([primaryKey isKindOfClass:[NSString class]] && [primaryKey length] == 0) {
        return nil;
    }
    if ([primaryKey isKindOfClass:[NSNumber class]] && [primaryKey integerValue] == 0) {
        return nil;
    }
    if ([primaryKey isKindOfClass:[NSNull class]]) {
        return nil;
    }

    RLMRealm *database = [[self databaseManager] currentDatabase];

    id response = [_modelClass objectInRealm:database forPrimaryKey:primaryKey];

    if (!response) {
        response = [_modelClass new];
        [response setValue:primaryKey forKey:_modelPrimaryKey];
        [database transactionIfNeeded:^{
            [database addOrUpdateObject:response];
        }];
    }
    return response;
}

- (id)requestValueFromObject:(id)object error:(NSError **)error
{
    if (![object isKindOfClass:_modelClass]) {
        if (error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Can't convert '%@' into PrimaryKey using %@", [object class], [self class]);
        }
        return nil;
    }
    return [object valueForKey:_modelPrimaryKey];
}

- (TRCValueTransformerType)externalTypes
{
    return TRCValueTransformerTypeNumber | TRCValueTransformerTypeString;
}

- (id)convertedResponseValue:(id)responseValue
{
    if ([responseValue isKindOfClass:[NSNumber class]] && _isStringPrimaryKey) {
        return [responseValue description];
    } else if ([responseValue isKindOfClass:[NSString class]] && !_isStringPrimaryKey) {
        return @([responseValue doubleValue]);
    }
    return responseValue;
}

@end
