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

#import "UITextField+Dimensions.h"
#import "UIView+Positioning.h"

@implementation UITextField (Dimensions)

- (void)ensureHasCorrectHeight
{
    if (self.height != 0) {
        return;
    }

    UITextField *tempField = [UITextField new];
    tempField.font = self.font;
    tempField.text = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    [tempField sizeToFit];

    self.height = tempField.height;
}

@end
