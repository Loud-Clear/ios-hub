////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 7.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIView+Shorthands.h"
#import "UIButton+Shorthands.h"
#import "UILabel+Shorthands.h"
#import "CCMacroses.h"


@implementation UIView (Shorthands)

- (UIView *)addView
{
    let view = [UIView new];
    [self addSubview:view];
    return view;
}

- (UIView *)addViewWithBgColor:(UIColor *)color
{
    let view = [UIView new];
    view.backgroundColor = color;
    [self addSubview:view];
    return view;
}

- (UIButton *)addButtonWithAction:(SEL)action
{
    let button = [UIButton withTarget:self action:action];
    [self addSubview:button];
    return button;
}

- (UIButton *)addButtonWithTarget:(id)target action:(SEL)action
{
    let button = [UIButton withTarget:target action:action];
    [self addSubview:button];
    return button;
}

- (UILabel *)addLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    let label = [UILabel withFont:font color:color];
    [self addSubview:label];
    return label;
}

- (UILabel *)addLabel
{
    let label = [UILabel new];
    [self addSubview:label];
    return label;
}

- (UITapGestureRecognizer *)addTapWithTarget:(id)target action:(SEL)action
{
    let rec = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:rec];
    self.userInteractionEnabled = YES;
    return rec;
}

@end
