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
#import "CCRequest.h"

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

static CCSaveMode SaveModeForRequest(id request)
{
    CCSaveMode saveMode = CCSaveModeInsertOrReplace;
    if ([request isKindOfClass:[CCRequest class]] && [request respondsToSelector:@selector(saveMode)]) {
        saveMode = [request saveMode];
    }
    return saveMode;
}

@implementation _CCRealmSavePostProcessor

- (id)postProcessResponseObject:(id)responseObject forRequest:(id<TRCRequest>)request postProcessError:(NSError **)error
{
    CCSaveMode saveMode = SaveModeForRequest(request);

    if (saveMode == CCSaveModeNone) {
        return responseObject;
    } else {
        __block id result = nil;
        [self.databaseManager.currentDatabase transactionIfNeeded:^{
            result = ReplaceObjectsInResponse(responseObject, [CCPersistentModel class], ^id(id object) {
                return [self savedIdFromModel:object withMode:saveMode];
            });
        }];
        [self.databaseManager.currentDatabase refresh];
        return result;
    }
}

- (TRCQueueType)queueType
{
    return TRCQueueTypeWork;
}

- (CCPersistentId *)savedIdFromModel:(CCPersistentModel *)model withMode:(CCSaveMode)mode
{
    if (mode == CCSaveModeInsertOrReplace) {
        [self.databaseManager.currentDatabase addOrUpdateObject:model];
    } else {
        //TODO: Update database with dictionary of Non-null properties
    }
    return [model persistentId];
}

@end


@implementation _CCRealmFetchPostProcessor

- (id)postProcessResponseObject:(id)responseObject forRequest:(id<TRCRequest>)request postProcessError:(NSError **)error
{
    CCSaveMode saveMode = SaveModeForRequest(request);

    if (saveMode == CCSaveModeNone) {
        return responseObject;
    } else {
        [self.databaseManager.currentDatabase refresh];
        id result = ReplaceObjectsInResponse(responseObject, [CCPersistentId class], ^id(id object) {
            return [self loadModelFromId:object];
        });
        return result;
    }
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
