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

@class CCEnvironment;
@class CCCurrentEnvironmentStorage;


extern NSString *CCEnvironmentStorageDidSaveNotification; // Associated object is CCEnvironment which was saved to UserDefaults
extern NSString *CCEnvironmentStorageDidDeleteNotification; // Associated object is CCEnvironment which was saved to UserDefaults

@interface CCEnvironmentStorage : NSObject

@property (nonatomic, strong) Class environmentClass;
@property (nonatomic, strong) CCCurrentEnvironmentStorage *currentStorage;

- (instancetype)initWithEnvironmentClass:(Class)clazz;

//-------------------------------------------------------------------------------------------
#pragma mark - Access
//-------------------------------------------------------------------------------------------

- (__kindof CCEnvironment *)environmentWithName:(NSString *)name;

- (NSArray<__kindof CCEnvironment *> *)availableEnvironments;

- (BOOL)canResetEnvironment:(__kindof CCEnvironment *)environment;

//-------------------------------------------------------------------------------------------
#pragma mark - Modify
//-------------------------------------------------------------------------------------------

- (__kindof CCEnvironment *)createEnvironmentByDuplicating:(__kindof CCEnvironment *)environment;

- (void)saveEnvironment:(__kindof CCEnvironment *)environment;

- (void)resetEnvironment:(__kindof CCEnvironment *)environment;

- (void)deleteEnvironment:(__kindof CCEnvironment *)environment;

@end