////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON REST CLIENT
//  Copyright 2015, Typhoon Rest Client Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////





#import "TRCValueTransformerNumber.h"
#import "TRCUtils.h"
#import "TyphoonRestClientErrors.h"


@implementation TRCValueTransformerNumber

- (NSNumberFormatter *)sharedNumberFormatter
{
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    return formatter;
}

- (id)objectFromResponseValue:(id)value error:(NSError **)error
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else {
        NSNumber *number = [[self sharedNumberFormatter] numberFromString:value];
        if (!number && error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeTransformation, @"Can't convert string '%@' to NSNumber", value);
        }
        return number;
    }
    return nil;
}

- (id)requestValueFromObject:(id)object error:(NSError **)error
{
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    } else if ([object isKindOfClass:[NSString class]]) {
        NSNumber *number = [[self sharedNumberFormatter] numberFromString:object];
        if (!number && error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeTransformation, @"Can't convert string '%@' to NSNumber", object);
        }
        return number;
    } else {
        if (error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeTransformation, @"Can't convert '%@' into string", [object class]);
        }
        return nil;
    }
}

- (TRCValueTransformerType)externalTypes
{
    return TRCValueTransformerTypeNumber | TRCValueTransformerTypeString;
}


@end