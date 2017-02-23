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
#import "RLMObject+ThreadSafety.h"

@class CCPersistentId;
@class TyphoonTypeDescriptor;

@interface CCPersistentModel : RLMObject

+ (NSArray *)serializedProperties;

- (void)beforeAddOrUpdate:(RLMRealm *)realm;

//Serialization customization
+ (Class)classForStorageForProperty:(NSString *)name;
- (id)deserializeValue:(id)serializedValue forPropertyName:(NSString *)name type:(TyphoonTypeDescriptor *)type;
- (id)serializeValue:(id)value forPropertyName:(NSString *)name type:(TyphoonTypeDescriptor *)type;

@end


NSString *CCDataPropertyNameFromName(NSString *propertyName);