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

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:posix];
    });
    return dateFormatter;
}

- (NSDate *)objectFromResponseValue:(NSString *)responseValue error:(NSError **)error
{
    NSDateFormatter *dateFormatter = [[self class] sharedDateFormatter];
    
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
    NSDateFormatter *dateFormatter = [[self class] sharedDateFormatter];
    
    NSString *string = [dateFormatter stringFromDate:object];
    
    if (!string && error) {
        *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Can't convert NSDate '%@' into NSStrign", object);
    }
    
    return string;
}

@end
