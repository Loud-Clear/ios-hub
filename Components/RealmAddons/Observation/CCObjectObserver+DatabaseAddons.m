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

#import "CCObjectObserver+DatabaseAddons.h"
#import <Typhoon/TyphoonIntrospectionUtils.h>
#import "TyphoonTypeDescriptor.h"
#import "CCCollectionSerialization.h"
#import "CCPersistentModel.h"

@implementation CCObjectObserver (DatabaseAddons)

- (BOOL)isSerializableKeyPath:(NSString *)key forInstance:(id)instance
{
    NSArray *pathComponents = [key componentsSeparatedByString:@"."];

    if ([pathComponents count] > 1) {
        NSArray *pathToPrevious = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 1)];
        NSString *keyPathToPrevious = [pathToPrevious componentsJoinedByString:@"."];
        id parentInstance = [instance valueForKeyPath:keyPathToPrevious];
        return [self isSerializableKeyPath:[pathComponents lastObject] forInstance:parentInstance];
    } else if ([pathComponents count] == 1) {
        if ([[instance class] respondsToSelector:@selector(serializedProperties)]) {
            //checking only one
            NSArray *serializableKeys = [[instance class] serializedProperties];
            return [serializableKeys containsObject:key];
        }
    }
    return NO;
}

- (NSString *)dataKeyFromObjectKey:(NSString *)key
{
    NSMutableArray *pathComponents = [[key componentsSeparatedByString:@"."] mutableCopy];

    if ([pathComponents count] > 1) {
        //Replacing last component
        NSString *dataKey = CCDataPropertyNameFromName([pathComponents lastObject]);
        pathComponents[[pathComponents count] - 1] = dataKey;
        return [pathComponents componentsJoinedByString:@"."];
    }
    else if ([pathComponents count] == 1) {
        return CCDataPropertyNameFromName(key);
    }

    return key;
}

- (NSDictionary *)deserializeValuesInChangeDictionary:(NSDictionary *)dictionary withObjectKey:(NSString *)objectKey instance:(id)instance
{
    TyphoonTypeDescriptor *type = nil;
    NSArray *pathComponents = [objectKey componentsSeparatedByString:@"."];
    NSString *propertyName = nil;

    if ([pathComponents count] > 1) {
        NSArray *pathToPrevious = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 1)];
        NSString *keyPathToPrevious = [pathToPrevious componentsJoinedByString:@"."];
        id parentInstance = [instance valueForKeyPath:keyPathToPrevious];
        propertyName = [pathComponents lastObject];
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:[parentInstance class]];
    }
    else if ([pathComponents count] == 1) {
        propertyName = objectKey;
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:[instance class]];
    }

    NSMutableDictionary *result = [dictionary mutableCopy];

    result[NSKeyValueChangeOldKey] = [self deserializeString:dictionary[NSKeyValueChangeOldKey] forProperty:propertyName toType:type onInstance:instance];
    result[NSKeyValueChangeNewKey] = [self deserializeString:dictionary[NSKeyValueChangeNewKey] forProperty:propertyName toType:type onInstance:instance];

    return result;
}

- (id)deserializeString:(id)value forProperty:(NSString *)name toType:(TyphoonTypeDescriptor *)type onInstance:(CCPersistentModel *)instance
{
    return [instance deserializeValue:value forPropertyName:name type:type];
}

@end

