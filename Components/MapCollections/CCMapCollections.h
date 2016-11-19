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

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (Map)

- (instancetype)arrayUsingMap:(ObjectType(^)(ObjectType object))mapBlock;

@end

@interface NSMutableArray<ObjectType> (Map)

- (void)map:(ObjectType(^)(ObjectType object))mapBlock;

@end

@interface NSSet<ObjectType> (Map)

- (instancetype)setUsingMap:(ObjectType(^)(ObjectType object))mapBlock;

@end

@interface NSMutableSet<ObjectType> (Map)

- (void)map:(ObjectType(^)(ObjectType object))mapBlock;

@end

@interface NSMutableDictionary< KeyType,  ObjectType> (Map)

- (void)mapObjects:(ObjectType(^)(KeyType key, ObjectType object))mapBlock;

- (void)mapKeys:(KeyType(^)(KeyType key, ObjectType object))mapBlock;

@end


@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (Map)

- (instancetype)dictionaryUsingObjectMap:(ObjectType(^)(KeyType key, ObjectType object))mapBlock;

- (instancetype)dictionaryUsingKeyMap:(KeyType(^)(KeyType key, ObjectType object))mapBlock;

@end
