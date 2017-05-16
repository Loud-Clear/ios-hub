////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2015 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of AppsQuick.ly
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCFileAndLineNumberFormatter.h"

@implementation CCFileAndLineNumberFormatter

+ (NSDateFormatter *)formatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyMMdd HH:mm:ss.SS"];
    });
    return formatter;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *path = logMessage.file;
    NSString *fileName = [path lastPathComponent];
    NSString *function = logMessage.function;
    NSString *dateString = [[[self class] formatter] stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"[%@] %@:%@ (%@) %@", dateString, fileName, @(logMessage.line), function,
                                      logMessage.message];
}

@end
