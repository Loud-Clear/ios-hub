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

#import "DTModulePromise.h"
#import "DTModuleFactory.h"

@class TyphoonComponentFactory;
@protocol DTTransitionHandler;
@protocol DTModule;

@interface DTModuleFactoryImplementation : NSObject <DTModuleFactory>

@property (nonatomic, strong) TyphoonComponentFactory *factory;

- (id<DTModule>)moduleForURL:(NSURL *)url thenChainUsingBlock:(DTModuleLinkBlock)block;

- (id<DTModule>)moduleForURL:(NSURL *)url;

- (id<DTModule>)moduleForStoryboard:(NSString *)storyboard
                         identifier:(NSString *)identifier;

- (id<DTModule>)moduleForViewControllerClass:(Class)clazz;



@end
