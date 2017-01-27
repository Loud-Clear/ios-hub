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

#import <TyphoonRestClient/TRCUtils.h>
#import "CCValueTransformerUnixTime.h"
#import "TyphoonRestClientErrors.h"


@implementation CCValueTransformerUnixTime


- (id)objectFromResponseValue:(NSNumber *)responseValue error:(NSError **)error
{
    double timeInterval = [responseValue doubleValue];
    if (timeInterval == 0) {
        return nil;
    } else {
        return [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
}

- (NSNumber *)requestValueFromObject:(id)object error:(NSError **)error
{
    if (![object isKindOfClass:[NSDate class]]) {
        if (error) {
            *error = TRCErrorWithFormat(TyphoonRestClientErrorCodeRequestSerialization, @"Can't get unit time from object %@", object);
        }
        return nil;
    }

    NSDate *date = object;

    return @([date timeIntervalSince1970]);
}

- (TRCValueTransformerType)externalTypes
{
    return TRCValueTransformerTypeNumber;
}


@end
