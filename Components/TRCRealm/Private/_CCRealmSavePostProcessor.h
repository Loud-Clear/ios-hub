//
//  _CCRealmPostProcessors.h
//  iOS Hub
//
//  Created by Aleksey Garbarev on 11/02/2017.
//  Copyright © 2017 Loud & Clear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAutoInjection.h>
#import "CCDatabaseManager.h"

@interface _CCRealmSavePostProcessor : NSObject <TRCPostProcessor>

@property (nonatomic) InjectedClass(CCDatabaseManager) databaseManager;

- (CCPersistentId *)savedIdFromModel:(CCPersistentModel *)model withMode:(CCSaveMode)mode;

@end

@interface _CCRealmFetchPostProcessor : NSObject <TRCPostProcessor>

@property (nonatomic) InjectedClass(CCDatabaseManager) databaseManager;

@end
