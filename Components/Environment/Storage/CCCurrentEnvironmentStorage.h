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

@class CCEnvironmentStorage;
@class CCEnvironment;


@interface CCCurrentEnvironmentStorage : NSObject

@property (nonatomic, strong) __kindof CCEnvironment *current;

- (instancetype)initWithStorage:(CCEnvironmentStorage *)storage;


@end