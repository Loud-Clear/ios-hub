////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "CCEnvironment.h"

@interface CCEnvironment (Private)

@property (nonatomic) NSString *filename;

/**
 * Connecting to storage makes:
 * - auto save. If property modified - it will automagically save to disk
 * - auto refresh. If another instance of environment with same filename changed, current will be automatically refreshed
 * */
- (void)connectToStorage;

- (void)copyPropertiesFrom:(CCEnvironment *)anotherEnvironment;

- (void)withoutSave:(void(^)())block;

@end