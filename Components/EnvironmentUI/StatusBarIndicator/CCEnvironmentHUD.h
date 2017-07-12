//
//  CCEnvironmentHUD.h
//  YoMojo
//
//  Created by Aleksey Garbarev on 09/06/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCEnvironment;

@interface CCEnvironmentHUD : NSObject

+ (instancetype)sharedHUD;

- (void)setLabelHidden:(BOOL)hidden;

- (void)setupWithEnvironment:(__kindof CCEnvironment *)environment;

@end
