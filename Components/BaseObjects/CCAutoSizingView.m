////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 30.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCAutoSizingView.h"
#import "UIView+Positioning.h"
#import "CCMacroses.h"

@implementation CCAutoSizingView

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (CGFloat)layoutVertically
{
    return 0;
}

- (CGFloat)layoutHorizontally
{
    return 0;
}

- (void)sizeToFitWidth:(CGFloat)width
{
    self.width = width;
    let height = [self layoutVertically];
    self.height = height;
}

- (void)sizeToFitHeight:(CGFloat)height
{
    self.height = height;
    let width = [self layoutHorizontally];
    self.width = width;
}

@end
