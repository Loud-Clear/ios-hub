//
//  CCEnvironmentHUD.h
//  YoMojo
//
//  Created by Aleksey Garbarev on 09/06/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCEnvironment;

/// Will automatically add current environment title to CCStatusBarHUD.
@interface CCEnvironmentHUD : NSObject

+ (instancetype)sharedHUD;

- (void)setupWithEnvironment:(__kindof CCEnvironment *)environment;

/// Use either NSTextAlignmentLeft or NSTextAlignmentRight.
/// Default is NSTextAlignmentRight.
@property (nonatomic) NSTextAlignment position;

@end
