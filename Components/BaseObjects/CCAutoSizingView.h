////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 30.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCView.h"

/**
 * View which can determine (and set) one of its dimensions based on the other one.
 */

@interface CCAutoSizingView : CCView

/// Will set self.width to width, and self.height to result of [self layoutVertically].
- (void)sizeToFitWidth:(CGFloat)width;

/// Will set self.height to height, and self.width to result of [self layoutHorizontally].
- (void)sizeToFitHeight:(CGFloat)height;


// For overriding:

/// Must perform layout, assuming that self.width is set correctly, but height is not known.
/// Returned value should be height after layout.
- (CGFloat)layoutVertically;

/// Must perform layout, assuming that self.height is set correctly, but width is not known.
/// Returned value should be width after layout.
- (CGFloat)layoutHorizontally;

@end
