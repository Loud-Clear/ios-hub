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
#import "CCHUDWindow.h"
#import "CCHUDView.h"
#import "CCMacroses.h"
#import "CCEnvironment.h"
#import "CCEnvironment+PresentingName.h"
#import <UIKit/UIKit.h>

@interface CCEnvironmentHUD ()

@property (nonatomic, strong) __kindof CCEnvironment *currentEnvironment;

@end

@implementation CCEnvironmentHUD
{
    CCHUDWindow *_hudWindow;
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
        [self addWindow];
    } else {
        [self registerForNotification:UIWindowDidBecomeKeyNotification selector:@selector(addWindow)];
    }
}

- (void)addWindow
{
    [self unregisterForNotification:UIWindowDidBecomeKeyNotification];


    SafetyCallOnMain(^{
        CGRect frame = [[UIApplication sharedApplication] keyWindow].frame;
        _hudWindow = [[CCHUDWindow alloc] initWithFrame:frame];
        _hudWindow.windowLevel = UIWindowLevelStatusBar;
        _hudWindow.hidden = NO;
        _hudWindow.userInteractionEnabled = NO;

        [self subscribeUpdateToNotifications];
    });
}

- (void)subscribeUpdateToNotifications
{
    _observer = [[CCObjectObserver alloc] initWithObject:self.currentEnvironment observer:nil];
    [_observer observeKeys:[self.currentEnvironment cc_titleNames] withAction:@selector(updateTitle)];
    [self updateTitle];
}

- (void)updateTitle
{
    _hudWindow.hudView.statusLabel.text = [self.currentEnvironment cc_presentingName];
}

- (void)setLabelHidden:(BOOL)hidden
{
    _hudWindow.hudView.statusLabel.hidden = hidden;
}

@end
