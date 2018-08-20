//
//  CCHUDView.m
//  StartFX-iOS
//
//  Created by Ivan on 09.03.13.
//
//

#import "CCStatusBarHUD.h"
#import <objc/runtime.h>
#import <PureLayout/PureLayoutDefines.h>
#import <PureLayout/ALView+PureLayout.h>
#import "CCNotificationUtils.h"

@interface HUDLabel : UILabel
@end

@implementation HUDLabel

- (CGSize)intrinsicContentSize
{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + 10, contentSize.height);
}

@end

NSString * CCViewControllerNeedsStatusBarAppearanceNotification = @"cc_setNeedsStatusBarAppearanceUpdate";

@interface UIViewController (UpdateStatusBarCallback)

@end

@implementation UIViewController (UpdateStatusBarCallback)

+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(setNeedsStatusBarAppearanceUpdate));
    Method m2 = class_getInstanceMethod(self, @selector(cc_setNeedsStatusBarAppearanceUpdate));
    method_exchangeImplementations(m1, m2);
}

- (void)cc_setNeedsStatusBarAppearanceUpdate
{
    [self cc_setNeedsStatusBarAppearanceUpdate];
    
    [NSNotificationCenter postNotificationToMainThread:CCViewControllerNeedsStatusBarAppearanceNotification];
}

@end


@implementation CCStatusBarHUD

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)sharedHUD
{
    static CCStatusBarHUD *sharedHud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHud = [CCStatusBarHUD new];
        [sharedHud setup];
    });
    return sharedHud;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.userInteractionEnabled = NO;

        [self setupLeftLabel];
        [self setupRightLabel];

        [self registerForNotification:CCViewControllerNeedsStatusBarAppearanceNotification selector:@selector(updateStatusBarAppearance)];

        [self updateStatusBarAppearance];
    }
    return self;
}

- (void)setup
{
    if ([[UIApplication sharedApplication] keyWindow]) {
        [self setupView];
    } else {
        [self registerForNotification:UIWindowDidBecomeKeyNotification selector:@selector(setupView)];
    }
}

- (void)setupView
{
    [self unregisterForNotification:UIWindowDidBecomeKeyNotification];

    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.frame = [self hudViewFrame];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.layer.zPosition = 100;
        self.userInteractionEnabled = NO;

        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        [mainWindow addSubview:self];
    });
}


- (void)setupRightLabel
{
    self.statusLabelRight = [self makeStatusLabel];
    [self addSubview:self.statusLabelRight];
    self.statusLabelRight.textAlignment = NSTextAlignmentCenter;
    [self.statusLabelRight autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    NSLayoutConstraint *rightLabelPadding = [NSLayoutConstraint constraintWithItem:self.statusLabelRight attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual toItem:self
                                                                         attribute:NSLayoutAttributeCenterX multiplier:1
                                                                          constant:35];
    [self addConstraint:rightLabelPadding];
}

- (void)setupLeftLabel
{
    self.statusLabelLeft = [self makeStatusLabel];
    [self addSubview:self.statusLabelLeft];
    self.statusLabelLeft.textAlignment = NSTextAlignmentCenter;
    [self.statusLabelLeft autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    NSLayoutConstraint *leftLabelPadding = [NSLayoutConstraint constraintWithItem:self.statusLabelLeft attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual toItem:self
                                                                        attribute:NSLayoutAttributeCenterX multiplier:1
                                                                         constant:-35];
    [self addConstraint:leftLabelPadding];
}

- (HUDLabel *)makeStatusLabel
{
    HUDLabel *statusLabel = [HUDLabel new];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:12];
    statusLabel.text = @"";
    statusLabel.layer.borderWidth = 1.0;

    return statusLabel;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (CGRect)hudViewFrame
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarSize = CGSizeMake(statusBarSize.height, statusBarSize.width);
    }
    return CGRectMake(0, 0, statusBarSize.width, statusBarSize.height);
}

- (void)updateStatusBarAppearance
{
    [self updateColor];
    [self updateFrameAndVisibility];
}

- (void)updateFrameAndVisibility
{
    self.hidden = [[UIApplication sharedApplication] isStatusBarHidden];
    self.frame = [self hudViewFrame];
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
    
    self.statusLabelLeft.textColor = color;
    self.statusLabelLeft.layer.borderColor = self.statusLabelLeft.textColor.CGColor;

    self.statusLabelRight.textColor = color;
    self.statusLabelRight.layer.borderColor = self.statusLabelLeft.textColor.CGColor;
}

@end
