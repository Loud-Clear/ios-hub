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

@import Foundation;

@interface NSMutableAttributedString (Shorthand)

+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)withString:(NSString *)string;

@end
