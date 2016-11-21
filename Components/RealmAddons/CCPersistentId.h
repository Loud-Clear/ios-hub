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
#import <Realm/RLMRealm.h>
#import "CCPersistentModel.h"

@class RLMResults;


@interface CCPersistentId : NSObject

@property (nonatomic, strong) id primaryKeyValue;
@property (nonatomic, strong) NSString *className;

- (instancetype)initWithModel:(CCPersistentModel *)model;

- (NSString *)primaryKey;

@end

@interface RLMRealm (ССPersistentId)

- (RLMResults *)objects:(NSString *)className WithPersistentIds:(NSArray<CCPersistentId *> *)modelIds;

@end

@interface NSArray (ССPersistentId)

- (NSArray<CCPersistentId *> *)persistentId;

@end

@interface CCPersistentModel (ССPersistentId)

- (CCPersistentId *)persistentId;

@end
