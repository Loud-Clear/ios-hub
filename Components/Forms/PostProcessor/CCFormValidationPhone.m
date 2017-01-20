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

#import "CCFormValidationPhone.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationPhone

- (instancetype) init
{
    if (!(self = [super init])) {
        return nil;
    }

    _minDigits = 9;
    _maxDigits = 12;

    return self;
}

+ (instancetype)withField:(NSString *)name
                minDigits:(NSInteger)minDigits minDigitsMessage:(NSString *)minDigitsMessage
                maxDigits:(NSInteger)maxDigits maxDigitsMessage:(NSString *)maxDigitsMessage
{
    NSParameterAssert(name);
    CCFormValidationPhone *filter = [CCFormValidationPhone new];
    filter.name = name;
    filter.minDigits = minDigits;
    filter.minDigitsMessage = minDigitsMessage;
    filter.maxDigits = maxDigits;
    filter.maxDigitsMessage = maxDigitsMessage;
    return filter;
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    id valueObject = data[self.name];

    if (!valueObject || ![valueObject isKindOfClass:[NSString class]]) {
        return YES;
    }

    NSString *value = valueObject;

    NSString *digitsString = [[value componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

    if ([digitsString length] < _minDigits) {
        if (error && _minDigitsMessage) {
            *error = [NSError errorWithLocalizedDescription:_minDigitsMessage];
        }
        return NO;
    }

    if ([digitsString length] > _maxDigits) {
        if (error && _maxDigitsMessage) {
            *error = [NSError errorWithLocalizedDescription:_maxDigitsMessage];
        }
        return NO;
    }

    return YES;
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)key
{
    return [self.name isEqual:key];
}

@end
