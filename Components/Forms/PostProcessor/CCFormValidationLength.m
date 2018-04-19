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

#import "CCFormValidationLength.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationLength
{

}
+ (instancetype)withField:(NSString *)name minLength:(NSUInteger)minLength error:(NSString *)errorMessage
{
    CCFormValidationLength *validation = [CCFormValidationLength new];
    validation.name = name;
    validation.minLength = @(minLength);
    validation.tooShortErrorMessage = errorMessage;
    return validation;
}

+ (instancetype)withField:(NSString *)name maxLength:(NSUInteger)maxLength error:(NSString *)errorMessage
{
    CCFormValidationLength *validation = [CCFormValidationLength new];
    validation.name = name;
    validation.maxLength = @(maxLength);
    validation.tooLongErrorMessage = errorMessage;
    return validation;
}

+ (instancetype)withField:(NSString *)name minLength:(NSUInteger)minLength tooShortError:(NSString *)tooShort
                maxLength:(NSUInteger)maxLength tooLongError:(NSString *)tooLong
{
    CCFormValidationLength *validation = [CCFormValidationLength new];
    validation.name = name;
    validation.maxLength = @(minLength);
    validation.maxLength = @(maxLength);
    validation.tooLongErrorMessage = tooLong;
    validation.tooShortErrorMessage = tooShort;
    return validation;
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    id value = data[self.name];

    if (value && [value isKindOfClass:[NSString class]]) {
        NSString *string = value;

        if (self.minLength) {
            if ([string length] < [self.minLength integerValue]) {
                if (error) {
                    *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.tooShortErrorMessage];
                }
                return NO;
            }
        }

        if (self.maxLength) {
            if ([string length] > [self.maxLength integerValue]) {
                if (error) {
                    *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.tooLongErrorMessage];
                }
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)name
{
    return [self.name isEqualToString:name];
}


@end
