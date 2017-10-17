////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSString+CommaSeparatedString.h"
#import "CCMacroses.h"

@implementation NSString (CommaSeparatedString)

+ (instancetype)commaSeparatedStringFrom:(NSString *)arg1 :(NSString *)arg2
{
    let values = [NSMutableArray<NSString *> new];

    if (arg1) {
        [values addObject:arg1];
    }
    if (arg2) {
        [values addObject:arg2];
    }

    return [values componentsJoinedByString:@", "];
}

+ (instancetype)commaSeparatedStringFrom:(NSString *)arg1 :(NSString *)arg2 :(NSString *)arg3
{
    let values = [NSMutableArray<NSString *> new];

    if (arg1) {
        [values addObject:arg1];
    }
    if (arg2) {
        [values addObject:arg2];
    }
    if (arg3) {
        [values addObject:arg3];
    }

    return [values componentsJoinedByString:@", "];
}

@end
