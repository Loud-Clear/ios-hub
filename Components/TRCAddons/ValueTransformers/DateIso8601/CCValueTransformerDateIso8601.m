////////////////////////////////////////////////////////////////////////////////
//
//  APPS QUICKLY
//  Copyright 2015 Apps Quickly Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Apps Quickly. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCValueTransformerDateIso8601.h"
#import "TRCUtils.h"
#import "TyphoonRestClientErrors.h"

@implementation CCValueTransformerDateIso8601

+ (NSDateFormatter *)requestDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    });
    return formatter;
}

+ (NSDateFormatter *)responseDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    });
    return formatter;
}

- (NSDate *)objectFromResponseValue:(NSString *)responseValue error:(NSError **)error
{
    if (![responseValue isKindOfClass:[NSString class]]) {
        if (error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Expected 'NSString' object, but got '%@'.", NSStringFromClass([responseValue class]));
        }
        return nil;
    }

    NSDateFormatter *dateFormatter = [[self class] responseDateFormatter];

    NSDate *date = [dateFormatter dateFromString:responseValue];
    if (!date && error) {
        *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeResponseSerialization, @"Can't create NSDate from string '%@'", responseValue);
    }
    return date;
}

- (NSString *)requestValueFromObject:(id)object error:(NSError **)error
{
    if (![object isKindOfClass:[NSDate class]]) {
        if (error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Can't convert '%@' into NSString using %@", [object class], [self class]);
        }
        return nil;
    }
    NSDateFormatter *dateFormatter = [[self class] requestDateFormatter];

    NSString *string = [dateFormatter stringFromDate:object];

    if (!string && error) {
        *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Can't convert NSDate '%@' into NSStrign", object);
    }

    return string;
}

@end
