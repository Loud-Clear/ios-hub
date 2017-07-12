////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2016 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <BaseModel/BaseModel.h>

/**
 CCEnvironment is used for storing "environments" - e.g. server addresses, and for switching
 between them in runtime.

 How to integrate:
 1. Subclass CCEnvironment
 2. Add your application-specific properties to inherited class.
 3. Override `environmentFilenames` method and return list of available environment filenames.
 4. Create and fill environment files (in plist format) and add them to application Resources.

 How to use in code:
 - Call your CCEnvironment's subclass `currentEnvironment` method to get current environment. At first time, environment
     will be loaded from first file returned from `environmentFilenames`.
 - To get list of all available environments, call `availableEnvironments`.
 - To switch to specific environment, just call `useEnvironment:` on previously created CCEnvironment subclass instance
     and pass other environment which you got from `availableEnvironments`.
 - All properties in CCEnvironment subclass are KVO-compliant, so to get notified of changes in some property,
     just observe changes for this property using KVO.
 - You can change any property in your subclass and it will be automatically persisted to disk. To change multiples properties
     and avoid multiple writes to disk after each change, call `batchSave:` and perform changes in block.
*/

@interface CCEnvironment : BaseModel <NSCopying>

+ (instancetype)currentEnvironment;
+ (void)setCurrentEnvironment:(__kindof CCEnvironment *)environment;

+ (NSArray<__kindof CCEnvironment *> *)availableEnvironments;

+ (instancetype)duplicate:(__kindof CCEnvironment *)environment;

+ (void)resetAll;

- (void)batchSave:(dispatch_block_t)saveBlock;

/// Checks whatever Environment has default values in plist, or it's transient (created by user at runtime)
- (BOOL)canReset;

/// Resets all environments to default values (provided from plist files).
- (void)reset;

/**
 * Delete duplicated environment
 * */
- (BOOL)canDelete;
- (void)delete;

/**
 * Plist filename
 * */
@property (nonatomic, readonly) NSString *filename;

/**
 * Use 'name' property for display purpose. User can edit this field.
 * This can be useful in case of creating new environments (by duplicating existing ones) at runtime
 *
 * By default, it points to 'filename'
 * */
@property (nonatomic, strong) NSString *name;


/// Override this method in your subclass:

+ (NSArray<NSString *> *)environmentFilenames;

@end
