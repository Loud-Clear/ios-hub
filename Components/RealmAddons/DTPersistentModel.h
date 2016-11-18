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

@class DTPersistentId;

@interface DTPersistentModel : RLMObject

+ (NSArray *)textSearchableKeys;

+ (NSArray *)serializedProperties;

- (void)beforeAddOrUpdate:(RLMRealm *)realm;

@end


NSString *DTDataPropertyNameFromName(NSString *propertyName);