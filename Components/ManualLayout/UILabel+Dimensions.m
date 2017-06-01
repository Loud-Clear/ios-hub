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

#import <UIKit/UIKit.h>
#import "UIView+Positioning.h"
#import "UILabel+Dimensions.h"


@implementation UILabel (Dimensions)

- (void)ensureHasCorrectHeight
{
    if (self.height != 0) {
        return;
    }

    UILabel *tempLabel = [UILabel new];
    tempLabel.font = self.font;
    tempLabel.text = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    [tempLabel sizeToFit];

    self.height = tempLabel.height;
}

@end
