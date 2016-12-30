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
#import "BaseModel.h"

/**
 CCEnvironment is used for storing "environments" - e.g. server addresses, and for switching
 between them in runtime.

 How to integrate:
 1. Subclass CCEnvironment
 2. Add your application-specific properties to inherited class.
 3. Override `environmentFilenames` method and return list of available environment filenames.
 4. Create and fill environment files (in plist format) and add them to application Resources.

 How to use in code:
 - Just create your CCEnvironment subclass instance to get current environment. At first time, environment
     will be loaded from first file returned from `environmentFilenames`.
 - To get list of all available environments, call `availableEnvironments`.
 - To switch to specific environment, just call `useEnvironment` on previously created CCEnvironment subclass instance
     and pass other environment which you got from `availableEnvironments`.
 - All properties in CCEnvironment subclass are KVO-compliant, so to get notified of changes in some property,
     observe changes for this property using KVO.
 - To change and save some value, just change the property value and it will be automatically saved. To change multiples values
     and avoid multiple writes to disk after each change, call `batchSave:` and perform changes in block.
*/

@interface CCEnvironment : BaseModel

+ (NSArray<CCEnvironment *> *)availableEnvironments;

- (void)useEnvironment:(CCEnvironment *)environment;

- (void)batchSave:(dispatch_block_t)saveBlock;


@property (nonatomic, readonly) NSString *filename;


/// Override this method in your subclass:

+ (NSArray<NSString *> *)environmentFilenames;

@end