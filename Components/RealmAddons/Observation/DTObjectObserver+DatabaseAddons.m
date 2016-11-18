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

#import "DTObjectObserver+DatabaseAddons.h"

#ifdef __DTObjectObserver__

#import <Typhoon/TyphoonIntrospectionUtils.h>
#import "TyphoonTypeDescriptor.h"
#import "DTDatabaseDictionary.h"
#import "DTPersistentModel.h"

@implementation DTObjectObserver (DatabaseAddons)

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
        NSString *dataKey = DTDataPropertyNameFromName([pathComponents lastObject]);
        pathComponents[[pathComponents count] - 1] = dataKey;
        return [pathComponents componentsJoinedByString:@"."];
    }
    else if ([pathComponents count] == 1) {
        return DTDataPropertyNameFromName(key);
    }

    return key;
}

- (NSDictionary *)deserializeValuesInChangeDictionary:(NSDictionary *)dictionary withObjectKey:(NSString *)objectKey instance:(id)instance
{
    TyphoonTypeDescriptor *type = nil;
    NSArray *pathComponents = [objectKey componentsSeparatedByString:@"."];

    if ([pathComponents count] > 1) {
        NSArray *pathToPrevious = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 1)];
        NSString *keyPathToPrevious = [pathToPrevious componentsJoinedByString:@"."];
        id parentInstance = [instance valueForKeyPath:keyPathToPrevious];
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:[pathComponents lastObject] inClass:[parentInstance class]];
    }
    else if ([pathComponents count] == 1) {
        type = [TyphoonIntrospectionUtils typeForPropertyNamed:objectKey inClass:[instance class]];
    }

    NSMutableDictionary *result = [dictionary mutableCopy];

    result[NSKeyValueChangeOldKey] = [self deserializeString:dictionary[NSKeyValueChangeOldKey] toType:type];
    result[NSKeyValueChangeNewKey] = [self deserializeString:dictionary[NSKeyValueChangeNewKey] toType:type];

    return result;
}

- (id)deserializeString:(NSString *)string toType:(TyphoonTypeDescriptor *)type
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return [(id<DTDatabaseJSONSerialization>)[type.typeBeingDescribed alloc] initWithJSONObject:jsonObject];
}

@end


#endif
