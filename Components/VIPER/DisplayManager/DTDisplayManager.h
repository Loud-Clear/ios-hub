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
#import "DTTransitionHandler.h"
#import "DTDisplayManagerAnimation.h"

@class TyphoonComponentFactory;
@protocol DTModulePromise;
@protocol DTWorkflow;

/**
 * Display Manager handles initial window state, and also aimed to switch workflow (storyboards) like
 * entry, home, etc
 * */
@interface DTDisplayManager : NSObject

@property (nonatomic, readonly, weak) UIWindow *window;
@property (nonatomic, readonly, strong) TyphoonComponentFactory *factory;
@property (nonatomic, strong) id<DTWorkflow> initialWorkflow;
@property (nonatomic) BOOL shouldEmulateIPhoneOnIPad;

- (void)setupWindow:(UIWindow *)window factory:(TyphoonComponentFactory *)factory;

- (void)replaceRootViewControllerWith:(UIViewController *)viewController animation:(DTDisplayManagerTransitionAnimation)animation;

- (id<DTModulePromise>)openModuleWithURL:(NSURL *)url transition:(DTTransitionStyle)style;

+ (void)animateChange:(void (^)())change onWindow:(UIWindow *)window
         withAnimtion:(DTDisplayManagerTransitionAnimation)animation;

- (CGSize)screenSize;
- (CGRect)screenBounds;
- (CGRect)windowFrame;

@end
