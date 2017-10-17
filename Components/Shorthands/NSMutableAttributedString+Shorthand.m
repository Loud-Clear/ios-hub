////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2016 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <NSAttributedString+CCLFormat/NSAttributedString+CCLFormat.h>
#import "NSMutableAttributedString+Shorthand.h"


@implementation NSMutableAttributedString (Shorthand)

+ (instancetype)withFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithFormat:format arguments:args];
    va_end(args);

    return result;
}

+ (instancetype)withString:(NSString *)string
{
    return [[NSMutableAttributedString alloc] initWithString:string];
}


@end
