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

#import "UIColor+Hex.h"
#import "UIColor+Components.h"

@implementation UIColor (Hex)

+ (UIColor *)withHex:(NSUInteger)rgbValue
{
    return [UIColor colorWithRed:(CGFloat) (((rgbValue & 0xFF0000) >> 16) / 255.0)
                           green:(CGFloat) (((rgbValue & 0xFF00) >> 8) / 255.0)
                            blue:(CGFloat) ((rgbValue & 0xFF) / 255.0)
                           alpha:1.0];
}

+ (UIColor *)withHex:(NSUInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(CGFloat) (((rgbValue & 0xFF0000) >> 16) / 255.0)
                           green:(CGFloat) (((rgbValue & 0xFF00) >> 8) / 255.0)
                            blue:(CGFloat) ((rgbValue & 0xFF) / 255.0)
                           alpha:alpha];
}

- (NSUInteger)hex
{
    return (NSUInteger)(self.red*255*0x10000 + self.green*255*0x100 + self.blue*255);
}

@end
