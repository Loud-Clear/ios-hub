////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 8.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <ComponentsHub/UILabel+SizeToFitMultiline.h>
#import "UILabel+EnsureFits.h"


@implementation UILabel (EnsureFits)

- (BOOL)ensureFitsSize:(CGSize)size fontSize:(CGFloat)fontSize
{
    let minFontSize = 8.0f;
    let fontStep = 1.0f;

    while (YES) {
        self.font = [UIFont fontWithName:self.font.fontName size:fontSize];
        [self sizeToFitMultilineWithWidth:size.width];
        if (self.height < size.height) {
            return YES;
        }

        if (fontSize <= minFontSize) {
            return NO;
        }

        fontSize -= fontStep;
    }

    return NO;
}

@end
