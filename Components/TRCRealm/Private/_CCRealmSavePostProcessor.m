//
//  _CCRealmPostProcessors.m
//  iOS Hub
//
//  Created by Aleksey Garbarev on 11/02/2017.
//  Copyright © 2017 Loud & Clear. All rights reserved.
//

#import <TyphoonRestClient/TyphoonRestClient.h>
#import <Typhoon/TyphoonComponentFactory.h>

#import "CCPersistentModel.h"
#import "CCRealmPostProcessor.h"
#import "CCMutableCollections.h"
#import "RLMRealm+NestedTransactions.h"
#import "_CCRealmSavePostProcessor.h"

static id ReplaceObjectsInResponse(id responseObject, Class clazzToReplace, id(^block)(id))
{
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray new];
        for (id object in responseObject) {
            id objectToReplace = ReplaceObjectsInResponse(object, clazzToReplace, block);
            if (objectToReplace) {
                [mutableArray addObject:objectToReplace];
            }
        }
        responseObject = mutableArray;
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [responseObject mutableDictionary];
        for (NSString *key in [mutableDictionary allKeys]) {
            id objectToReplace = ReplaceObjectsInResponse(mutableDictionary[key], clazzToReplace, block);
            if (objectToReplace) {
                mutableDictionary[key] = objectToReplace;
            }
        }
        responseObject = mutableDictionary;
    } else if ([responseObject isKindOfClass:clazzToReplace]) {
        responseObject = block(responseObject);
    }
    return responseObject;
}

@implementation _CCRealmSavePostProcessor

- (id)postProcessResponseObject:(id)responseObject forRequest:(id<TRCRequest>)request postProcessError:(NSError **)error
{
    return ReplaceObjectsInResponse(responseObject, [CCPersistentModel class], ^id(id object) {
        return [self savedIdFromModel:object withMode:CCSaveModeInsertOrReplace];
    });
}

- (TRCQueueType)queueType
{
    return TRCQueueTypeWork;
}

- (CCPersistentId *)savedIdFromModel:(CCPersistentModel *)model withMode:(CCSaveMode)mode
{
    if (mode == CCSaveModeInsertOrReplace) {
        [self.databaseManager.currentDatabase transactionIfNeeded:^{
            [self.databaseManager.currentDatabase addOrUpdateObject:model];
        }];
        [self.databaseManager.currentDatabase refresh];
    } else {
        //TODO: Update database with dictionary of Non-null properties
    }
    return [model persistentId];
}

@end


@implementation _CCRealmFetchPostProcessor

- (id)postProcessResponseObject:(id)responseObject forRequest:(id<TRCRequest>)request postProcessError:(NSError **)error
{
    return ReplaceObjectsInResponse(responseObject, [CCPersistentId class], ^id(id object) {
        return [self loadModelFromId:object];
    });
}

- (TRCQueueType)queueType
{
    return TRCQueueTypeCallback;
}

- (CCPersistentModel *)loadModelFromId:(CCPersistentId *)persistentId
{
    [self.databaseManager.currentDatabase refresh];
    return [self.databaseManager objectFromId:persistentId];
}

@end
