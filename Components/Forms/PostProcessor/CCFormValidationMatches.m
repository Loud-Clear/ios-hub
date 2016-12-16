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

#import "CCFormValidationMatches.h"
#import "NSError+CCTableFormManager.h"

@implementation CCFormValidationMatches

+ (instancetype)withField:(NSString *)name shouldMatch:(NSString *)nameToMatch error:(NSString *)message
{
    CCFormValidationMatches *validator = [CCFormValidationMatches new];
    validator.name = name;
    validator.nameToMatch = nameToMatch;
    validator.errorMessage = message;
    return validator;
}

+ (instancetype)withField:(NSString *)name shouldMatch:(NSString *)nameToMatch caseSensitive:(BOOL)caseSensitive error:(NSString *)message
{
    CCFormValidationMatches *validator = [CCFormValidationMatches new];
    validator.name = name;
    validator.nameToMatch = nameToMatch;
    validator.errorMessage = message;
    validator.caseSensitive = caseSensitive;
    return validator;
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    id first = [self stringFromValue:data[self.name]];
    id second = [self stringFromValue:data[self.nameToMatch]];
    
    if (![first isEqual:second]) {
        if (error) {
            *error = [NSError errorWithCode:0 name:self.nameToMatch localizedDescription:self.errorMessage];
        }
        return NO;
    }
    return YES;
}

- (NSString *)stringFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return self.caseSensitive ? value : [value lowercaseString];
    } else {
        return nil;
    }
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)key
{
    return [self.nameToMatch isEqual:key];
}

@end
