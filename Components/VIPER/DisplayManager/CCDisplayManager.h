////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "CCTransitionHandler.h"
#import "CCDisplayManagerAnimation.h"

@class TyphoonComponentFactory;
@protocol CCModulePromise;
@protocol CCWorkflow;

/**
 * Display Manager handles initial window state, and also aimed to switch workflow (storyboards) like
 * entry, home, etc
 * */
@interface CCDisplayManager : NSObject

@property (nonatomic, readonly, weak) UIWindow *window;
@property (nonatomic, readonly, strong) TyphoonComponentFactory *factory;
@property (nonatomic, strong) id<CCWorkflow> initialWorkflow;

- (void)setupWindow:(UIWindow *)window factory:(TyphoonComponentFactory *)factory;

- (void)replaceRootViewControllerWith:(UIViewController *)viewController animation:(CCDisplayManagerTransitionAnimation)animation;

- (id<CCModulePromise>)openModuleWithURL:(NSURL *)url transition:(ССTransitionStyle)style;

+ (void)animateChange:(void (^)())change onWindow:(UIWindow *)window
         withAnimtion:(CCDisplayManagerTransitionAnimation)animation;

- (CGSize)screenSize;
- (CGRect)screenBounds;
- (CGRect)windowFrame;

@end
