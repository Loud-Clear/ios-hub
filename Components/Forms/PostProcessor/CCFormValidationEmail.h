////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "CCFormPostProcessor.h"


@interface CCFormValidationEmail : NSObject <CCFormPostProcessor>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *errorMessage;

+ (instancetype)withField:(NSString *)name error:(NSString *)message;

@end
