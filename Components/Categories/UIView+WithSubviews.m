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

#import "UIView+WithSubviews.h"


@implementation UIView (WithSubviews)

+ (instancetype)withSubviews:(NSArray<UIView *> *)subviews
{
    UIView *view = [UIView new];

    for (UIView *subview in subviews) {
        [view addSubview:subview];
    }

    return view;
}

+ (instancetype)withSubviewsBlock:(NSArray<UIView *> *(^)())subviewsBlock
{
    NSArray<UIView *> *subviews = nil;
    if (subviewsBlock) {
        subviews = subviewsBlock();
    }

    return [self withSubviews:subviews];
}

@end
