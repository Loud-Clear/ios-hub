//
//  CCHUDView.m
//  StartFX-iOS
//
//  Created by Ivan on 09.03.13.
//
//

#import "CCHUDView.h"
#import "UIView+Positioning.h"
#import "ALView+PureLayout.h"
#import "CCObjectObserver.h"

@interface HUDLabel : UILabel

@end

@implementation HUDLabel

- (CGSize)intrinsicContentSize
{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + 10, contentSize.height);
}

@end


@implementation CCHUDView {
    CCObjectObserver *_applicationObserver;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;

        self.statusLabel = [HUDLabel new];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:12];
        self.statusLabel.text = @"";
        self.statusLabel.layer.borderWidth = 1.0;

        [self addSubview:self.statusLabel];

        self.statusLabel.textAlignment = NSTextAlignmentCenter;

        [self.statusLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];


        NSLayoutConstraint *padding = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual toItem:self
                                                                attribute:NSLayoutAttributeCenterX multiplier:1
                                                                 constant:-25];
        [self addConstraint:padding];


        UIApplication *application = [UIApplication sharedApplication];

        _applicationObserver = [[CCObjectObserver alloc] initWithObject:application observer:self];
        [_applicationObserver observeKeys:@[@"statusBarStyle"] withAction:@selector(updateColor)];

        [self updateColor];
    }
    return self;
}

- (void)updateColor
{
    UIStatusBarStyle style = [[UIApplication sharedApplication] statusBarStyle];
    UIColor *color = nil;
    if (style == UIStatusBarStyleLightContent) {
        color = [UIColor whiteColor];
    } else {
        color = [UIColor blackColor];
    }

    self.statusLabel.textColor = color;
    self.statusLabel.layer.borderColor = self.statusLabel.textColor.CGColor;
}

@end
