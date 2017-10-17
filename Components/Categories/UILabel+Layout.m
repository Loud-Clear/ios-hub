//
//  UILabel+Layout.m
//  Fish
//
//  Created by Michael Rublev on 18/07/2017.
//  Copyright © 2017 Loud&Clear. All rights reserved.
//

#import "UILabel+Layout.h"
#import "UIView+Positioning.h"

@implementation UILabel (Layout)

- (void)sizeToFitWidth:(CGFloat)width
{
    CGSize expectedSize = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    expectedSize.width = width;
    self.size = expectedSize;
}

@end
