////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCFormValidationBoolean.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationBoolean

+ (instancetype)withField:(NSString *)name correctValue:(BOOL)value error:(NSString *)errorMessage
{
    CCFormValidationBoolean *validator = [CCFormValidationBoolean new];
    validator.name = name;
    validator.expectedValue = value;
    validator.errorMessage = errorMessage;
    return validator;
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    NSNumber *value = data[self.name];
    if ([value boolValue] != self.expectedValue) {
        if (error) {
            *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.errorMessage];
        }
        return NO;
    }
    return YES;
}

@end
