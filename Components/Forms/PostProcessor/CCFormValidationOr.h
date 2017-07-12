////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCFormPostProcessor.h"


@interface CCFormValidationOr : NSObject <CCFormPostProcessor>

@property (nonatomic) NSArray<id<CCFormPostProcessor>> *postProcessors;
@property (nonatomic) NSString *message;

+ (instancetype)withPostProcessors:(NSArray<id<CCFormPostProcessor>> *)postProcessors message:(NSString *)message;
+ (instancetype)withPostProcessors:(NSArray<id<CCFormPostProcessor>> *)postProcessors;

@end
