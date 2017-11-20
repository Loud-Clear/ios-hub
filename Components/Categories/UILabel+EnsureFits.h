////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 8.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@interface UILabel (EnsureFits)

/**
 * Will try to decrease font size until label content fits 'size'.
 */
- (BOOL)ensureFitsSize:(CGSize)size fontSize:(CGFloat)fontSize;

@end
