////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 7.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


@interface UIView (Shorthands)

- (UIView *)addView;
- (UIView *)addViewWithBgColor:(UIColor *)color;

- (UIButton *)addButtonWithAction:(SEL)action;
- (UIButton *)addButtonWithTarget:(id)target action:(SEL)action;

- (UILabel *)addLabel;
- (UILabel *)addLabelWithFont:(UIFont *)font color:(UIColor *)color;

- (UITapGestureRecognizer *)addTapWithTarget:(id)target action:(SEL)action;

@end
