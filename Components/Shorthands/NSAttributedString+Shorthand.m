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

#import "NSAttributedString+Shorthand.h"
#import "NSAttributedString+CCLFormat.h"


@implementation NSAttributedString (Shorthand)

+ (instancetype)withAttributes:(NSDictionary *)attributes format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    NSAttributedString *result = [[self alloc] initWithAttributes:attributes format:string arguments:nil];
    va_end(args);

    return result;
}

+ (instancetype)withFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSAttributedString *result = [[self alloc] initWithFormat:format arguments:args];
    va_end(args);

    return result;
}

+ (instancetype)withString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs
{
    return [[self alloc] initWithString:str attributes:attrs];
}

+ (instancetype)withAttributes:(NSDictionary<NSString *, id> *)attrs string:(NSString *)str
{
    return [[self alloc] initWithString:str attributes:attrs];
}

@end
