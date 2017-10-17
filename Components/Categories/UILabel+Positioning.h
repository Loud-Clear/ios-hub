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

@import UIKit;

@interface UILabel (Positioning)

///
/// Adjusts vertical position of label so that middle of lowercase letters is at provided 'y' coordinate.
///
///
///  Example (this is UILabel with text "For"):
///  +--------------------------------------+
///  |                                      |
///  |  +---                                |
///  |  |                                   |
///  |  +---   /--\   |/--                  | <- middle of UILabel, also middle of uppercase letters (in this case).
///  |  |     |    |  |                     | <- middle of lowercase letters
///  |  |      \__/   |                     |
///  |                                      |^^^^^^ <- baseline
///  +--------------------------------------+
///

@property (nonatomic) CGFloat lowercaseCenterY;
@property (nonatomic) CGFloat uppercaseCenterY;
@property (nonatomic) CGFloat baselineY;

@end
