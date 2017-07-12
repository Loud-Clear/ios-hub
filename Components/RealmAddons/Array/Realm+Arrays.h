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

NSMutableSet *CCPrimaryKeysFromCollection(id<NSFastEnumeration> collection, NSString *primaryKey);

@interface RLMResults (Array)

- (NSArray *)allObjects;

- (NSMutableSet *)primaryKeysSet;

@end

@interface RLMArray (Array)

+ (id)arrayWithArray:(NSArray *)array objectsClass:(Class)clazz;

- (NSArray *)allObjects;

- (NSMutableSet *)primaryKeysSet;

@end
