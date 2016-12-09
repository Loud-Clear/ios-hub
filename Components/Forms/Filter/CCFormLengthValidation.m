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

#import "CCFormLengthValidation.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormLengthValidation
{

}
+ (instancetype)validationWithName:(NSString *)name minLength:(NSUInteger)minLength error:(NSString *)errorMessage
{
    CCFormLengthValidation *validation = [CCFormLengthValidation new];
    validation.name = name;
    validation.minLength = @(minLength);
    validation.tooShortErrorMessage = errorMessage;
    return validation;
}

+ (instancetype)validationWithName:(NSString *)name maxLength:(NSUInteger)maxLength error:(NSString *)errorMessage
{
    CCFormLengthValidation *validation = [CCFormLengthValidation new];
    validation.name = name;
    validation.maxLength = @(maxLength);
    validation.tooLongErrorMessage = errorMessage;
    return validation;
}

+ (instancetype)validationWithName:(NSString *)name minLength:(NSUInteger)minLength tooShortError:(NSString *)tooShort
                         maxLength:(NSUInteger)maxLength tooLongError:(NSString *)tooLong
{
    CCFormLengthValidation *validation = [CCFormLengthValidation new];
    validation.name = name;
    validation.maxLength = @(minLength);
    validation.maxLength = @(maxLength);
    validation.tooLongErrorMessage = tooLong;
    validation.tooShortErrorMessage = tooShort;
    return validation;
}

- (void)filterFormData:(NSMutableDictionary<NSString *, id> *)formData validationError:(NSError **)error
{
    id value = formData[self.name];

    if (value && [value isKindOfClass:[NSString class]]) {
        NSString *string = value;

        if (self.minLength) {
            if ([string length] < [self.minLength integerValue]) {
                *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.tooShortErrorMessage];
            }
            return;
        }

        if (self.maxLength) {
            if ([string length] > [self.maxLength integerValue]) {
                *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.tooLongErrorMessage];
            }
        }
    }
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)name
{
    return [self.name isEqualToString:name];
}


@end