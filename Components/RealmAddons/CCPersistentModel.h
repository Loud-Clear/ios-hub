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

@interface CCPersistentModel : RLMObject

+ (NSArray *)serializedProperties;

@end


NSString *CCDataPropertyNameFromName(NSString *propertyName);