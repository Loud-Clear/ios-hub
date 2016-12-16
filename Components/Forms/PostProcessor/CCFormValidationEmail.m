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

#import "CCFormValidationEmail.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationEmail

+ (instancetype)withField:(NSString *)name error:(NSString *)message
{
    NSParameterAssert(name && message);
    CCFormValidationEmail *filterEmail = [CCFormValidationEmail new];
    filterEmail.name = name;
    filterEmail.errorMessage = message;
    return filterEmail;
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    NSString *value = data[self.name];

    if (value && [value isKindOfClass:[NSString class]]) {
        NSError *regexpError = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&regexpError];
        NSTextCheckingResult *match = [regex firstMatchInString:value options:0 range:NSMakeRange(0, value.length)];

        if (!match) {
            if (error) {
                *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.errorMessage];
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)key
{
    return [self.name isEqual:key];
}

@end
