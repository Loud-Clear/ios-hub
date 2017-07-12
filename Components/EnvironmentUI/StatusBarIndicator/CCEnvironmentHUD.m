//
//  CCEnvironmentHUD.m
//  YoMojo
//
//  Created by Aleksey Garbarev on 09/06/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import "CCNotificationUtils.h"
#import "CCObjectObserver.h"
#import "CCEnvironmentHUD.h"
#import "CCHUDView.h"
#import "CCMacroses.h"
#import "CCEnvironment.h"
#import "CCEnvironment+PresentingName.h"
#import "CCHUDView.h"
#import <UIKit/UIKit.h>

@interface CCEnvironmentHUD ()

@property (nonatomic, strong) __kindof CCEnvironment *currentEnvironment;
@property (nonatomic, strong) CCHUDView *hudView;
@end

@implementation CCEnvironmentHUD
{
    CCObjectObserver *_observer;
}

+ (instancetype)sharedHUD
{
    static CCEnvironmentHUD *sharedHud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHud = [CCEnvironmentHUD new];
    });
    return sharedHud;
}

- (void)setupWithEnvironment:(__kindof CCEnvironment *)environment
{
    NSAssert(self.currentEnvironment == nil, @"CCEnvironmentHUD already configured");
    self.currentEnvironment = environment;
    [self setup];
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

    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.hudView = [[CCHUDView alloc] initWithFrame:[self hudViewFrame]];
        self.hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.hudView.layer.zPosition = 100;
        self.hudView.userInteractionEnabled = NO;
        
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        [mainWindow addSubview:self.hudView];
        
        [self subscribeUpdateToNotifications];
    });
}

- (CGRect)hudViewFrame
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarSize = CGSizeMake(statusBarSize.height, statusBarSize.width);
    }
    return CGRectMake(0, 0, statusBarSize.width, statusBarSize.height);
}

- (void)subscribeUpdateToNotifications
{
    _observer = [[CCObjectObserver alloc] initWithObject:self.currentEnvironment observer:self];
    [_observer observeKeys:[self.currentEnvironment cc_titleNames] withAction:@selector(updateTitle)];
    [self updateTitle];
}

- (void)updateTitle
{
    self.hudView.statusLabel.text = [self.currentEnvironment cc_presentingName];
}

- (void)setLabelHidden:(BOOL)hidden
{
    self.hudView.statusLabel.hidden = hidden;
}

@end
