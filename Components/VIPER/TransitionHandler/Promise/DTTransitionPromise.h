//
//  DTTransitionPromise.h
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "DTModulePromise.h"
#import <UIKit/UIKit.h>

@protocol DTGeneralModuleInput;

@interface DTTransitionPromise : NSObject <DTModulePromise>

@property (nonatomic, strong) id<DTGeneralModuleInput> moduleInput;
@property (nonatomic, strong) UIViewController *nextViewController;

- (void)addPostLinkBlock:(void (^)(id<DTGeneralModuleInput> moduleInput, UIViewController *nextViewController))postLinkBlock;

@end
