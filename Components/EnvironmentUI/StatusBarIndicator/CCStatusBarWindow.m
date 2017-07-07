//
//  CCStatusBarWindow.m
//  StartFX-iOS
//
//  Created by Ivan on 18.03.13.
//
//

#import <UIKit/UIKit.h>
#import "CCStatusBarWindow.h"
#import "CCNotificationUtils.h"

static CGFloat AngleFromInterfaceOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle = 0;

    if (orientation == UIInterfaceOrientationPortrait) {
        angle = 0;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        angle = M_PI_2;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        angle = M_PI;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        angle = M_PI + M_PI_2;
    }

    return angle;
}

__unused static CGFloat AngleFromTransform(CGAffineTransform transform)
{
    CGFloat result = atan2(transform.b, transform.a);
    return result;
}

@interface CCStatusBarWindow ()
@property (nonatomic) UIView *view;
@end

@implementation CCStatusBarWindow
{
    UIInterfaceOrientation statusBarOrientation;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;

        self.view = [UIView new];
        [self doLayoutSubviews];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.view];

        [self registerForNotification:UIApplicationWillChangeStatusBarOrientationNotification
                             selector:@selector(applicationWillChangeStatusBarOrientation:)];
    }
    return self;
}

- (void)applicationWillChangeStatusBarOrientation:(NSNotification *)notification
{
    NSNumber *newOrientationNumber = [notification userInfo][UIApplicationStatusBarOrientationUserInfoKey];
    statusBarOrientation = [newOrientationNumber integerValue];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self doLayoutSubviews];
    }                completion:nil];
}

- (void)doLayoutSubviews
{
    if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
        self.view.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        self.view.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }

    self.view.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    CGFloat angle = AngleFromInterfaceOrientation(statusBarOrientation);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.view.transform = transform;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self doLayoutSubviews];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self.view) {
        return nil;
    }
    return hitView;
}

@end
