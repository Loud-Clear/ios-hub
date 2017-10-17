//
//  NSDictionary+SafeAccess.m
//  OwlCity
//
//  Created by Ivan on 03.05.11.
//  Copyright 2011 Al Digit. All rights reserved.
//

#import "NSDictionary+SafeAccess.h"


///////////////////////////////////////////////////////////////////////////////////////////
@implementation NSDictionary (SafeAccess)

- (id)strictObjectOfClass:(Class)cls forKey:(id)key
{
    id object = self[key];
    if ([object isKindOfClass:cls]) {
        return object;
    } else {
        return nil;
    }
}

- (id)safeObjectOfClass:(Class)cls forKey:(id)key
{
    id object = self[key];
    if ([object isKindOfClass:cls]) {
        return object;
    } else {
        return [cls new];
    }
}

- (NSString *)stringForKey:(id)key
{
    return [self strictObjectOfClass:[NSString class] forKey:key];
}

- (NSString *)safeStringForKey:(id)key
{
    return [self safeObjectOfClass:[NSString class] forKey:key];
}

- (NSNumber *)numberForKey:(id)key
{
    return [self strictObjectOfClass:[NSNumber class] forKey:key];
}

- (NSNumber *)safeNumberForKey:(id)key
{
    return [self safeObjectOfClass:[NSNumber class] forKey:key];
}

- (NSNumber *)smartNumberForKey:(id)key
{
    NSNumber *number = [self numberForKey:key];

    if (number) {
        return number;
    }

    NSString *str = [self stringForKey:key];
    if (!str) {
        return nil;
    }

    return @([str floatValue]);
}

- (NSNumber *)safeSmartNumberForKey:(id)key
{
    NSNumber *number = [self smartNumberForKey:key];

    return number;
}

- (NSString *)smartStringForKey:(id)key
{
    NSNumber *number = [self numberForKey:key];

    if (number) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterNoStyle];

        return [formatter stringFromNumber:number];
    }

    return [self stringForKey:key];
}

- (NSString *)safeSmartStringForKey:(id)key
{
    NSString *string = [self smartStringForKey:key];

    if (string) {
        return string;
    } else {
        return @"";
    }
}

- (NSDecimalNumber *)decimalNumberForKey:(id)key
{
    return [self strictObjectOfClass:[NSDecimalNumber class] forKey:key];
}

- (NSDecimalNumber *)safeDecimalNumberForKey:(id)key
{
    return [self safeObjectOfClass:[NSDecimalNumber class] forKey:key];
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    return [self strictObjectOfClass:[NSDictionary class] forKey:key];
}

- (NSDictionary *)safeDictionaryForKey:(id)key
{
    return [self safeObjectOfClass:[NSDictionary class] forKey:key];
}

- (NSArray *)arrayForKey:(id)key
{
    return [self strictObjectOfClass:[NSArray class] forKey:key];
}

- (NSArray *)safeArrayForKey:(id)key
{
    return [self safeObjectOfClass:[NSArray class] forKey:key];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
@implementation NSMutableDictionary (SafeAccess)

- (void)safeSetObject:(id)object forKey:(id)key
{
    if (object && key) {
        self[key] = object;
    }
}

@end
