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

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)withHex:(NSUInteger)rgbValue;
+ (UIColor *)withHex:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

@end
