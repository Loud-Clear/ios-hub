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
#import "CCFormFilter.h"


@interface CCFormLengthValidation : NSObject <CCFormFilter>

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *minLength;
@property (nonatomic) NSNumber *maxLength;
@property (nonatomic) NSString *tooShortErrorMessage;
@property (nonatomic) NSString *tooLongErrorMessage;

+ (instancetype)validationWithName:(NSString *)name minLength:(NSUInteger)minLength error:(NSString *)errorMessage;

+ (instancetype)validationWithName:(NSString *)name maxLength:(NSUInteger)maxLength error:(NSString *)errorMessage;

+ (instancetype)validationWithName:(NSString *)name minLength:(NSUInteger)minLength tooShortError:(NSString *)tooShort
                         maxLength:(NSUInteger)maxLength tooLongError:(NSString *)tooLong;

@end