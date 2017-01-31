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


@interface CCFormValidationPhone : NSObject <CCFormPostProcessor>

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger minDigits;
@property (nonatomic) NSString *minDigitsMessage;
@property (nonatomic) NSInteger maxDigits;
@property (nonatomic) NSString *maxDigitsMessage;

+ (instancetype)withField:(NSString *)name
                minDigits:(NSInteger)minDigits minDigitsMessage:(NSString *)minDigitsMessage
                maxDigits:(NSInteger)maxDigits maxDigitsMessage:(NSString *)maxDigitsMessage;

@end
