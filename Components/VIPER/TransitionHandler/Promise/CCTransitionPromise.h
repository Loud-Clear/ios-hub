//
//  CCTransitionPromise.h
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCModulePromise.h"
#import <UIKit/UIKit.h>

@protocol CCGeneralModuleInput;

@interface CCTransitionPromise : NSObject <CCModulePromise>

@property (nonatomic, strong) id<CCGeneralModuleInput> moduleInput;
@property (nonatomic, strong) UIViewController *nextViewController;

- (void)addPostLinkBlock:(void (^)(id<CCGeneralModuleInput> moduleInput, UIViewController *nextViewController))postLinkBlock;

@end
