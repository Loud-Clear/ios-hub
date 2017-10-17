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

@import Foundation;

@interface NSAttributedString (Shorthand)

+ (instancetype)withAttributes:(NSDictionary *)attributes format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)withString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs;
+ (instancetype)withAttributes:(NSDictionary<NSString *, id> *)attrs string:(NSString *)str;

@end
