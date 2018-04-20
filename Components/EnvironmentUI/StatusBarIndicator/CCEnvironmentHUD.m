//
//  CCEnvironmentHUD.m
//  YoMojo
//
//  Created by Aleksey Garbarev on 09/06/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import <BaseModel/BaseModel.h>
#import "CCNotificationUtils.h"
#import "CCObjectObserver.h"
#import "CCEnvironmentHUD.h"
#import "CCStatusBarHUD.h"
#import "CCMacroses.h"
#import "CCEnvironment.h"
#import "CCEnvironment+PresentingName.h"
#import "CCStatusBarHUD.h"
#import <UIKit/UIKit.h>
#import "NSObject+Observe.h"


@implementation CCEnvironmentHUD
{
    __kindof CCEnvironment *_currentEnvironment;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)sharedHUD
{
    CC_IMPLEMENT_SHARED_SINGLETON(CCEnvironmentHUD);
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.position = NSTextAlignmentRight;

    return self;
}

- (void)setupWithEnvironment:(__kindof CCEnvironment *)environment
{
    NSAssert(_currentEnvironment == nil, @"CCEnvironmentHUD already configured");
    _currentEnvironment = environment;
    [self setup];
}

- (void)setup
{
    [self observe:_currentEnvironment keys:[_currentEnvironment cc_presentingNameKeys] action:@selector(update)];

    [self update];
}

- (void)setPosition:(NSTextAlignment)position
{
    _position = position;

    [self update];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)update
{
    if (_position == NSTextAlignmentLeft) {
        [CCStatusBarHUD sharedHUD].statusLabelLeft.text = [_currentEnvironment cc_presentingNameHUD];
    } else if (_position == NSTextAlignmentRight) {
        [CCStatusBarHUD sharedHUD].statusLabelRight.text = [_currentEnvironment cc_presentingNameHUD];
    }
}

@end
