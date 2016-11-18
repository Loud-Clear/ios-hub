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
#import "DTPersistentModel.h"

@class RLMResults;


@interface DTPersistentId : NSObject

@property (nonatomic, strong) id primaryKeyValue;
@property (nonatomic, strong) NSString *className;

- (instancetype)initWithModel:(DTPersistentModel *)model;

- (NSString *)primaryKey;

@end

@interface RLMRealm (DTPersistentId)

- (RLMResults *)objects:(NSString *)className WithPersistentIds:(NSArray<DTPersistentId *> *)modelIds;

@end

@interface NSArray (DTPersistentId)

- (NSArray<DTPersistentId *> *)persistentId;

@end

@interface DTPersistentModel (DTPersistentId)

- (DTPersistentId *)persistentId;

@end