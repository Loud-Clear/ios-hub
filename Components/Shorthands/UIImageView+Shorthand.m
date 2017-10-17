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

#import "UIImageView+Shorthand.h"


@implementation UIImageView (Shorthand)

+ (instancetype)withImage:(nullable UIImage *)image
{
    return [[UIImageView alloc] initWithImage:image];
}

@end
