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

#import "CCModulePromise.h"
#import "CCModuleFactory.h"

@class TyphoonComponentFactory;
@protocol CCTransitionHandler;
@protocol CCModule;

@interface CCModuleFactoryImplementation : NSObject <CCModuleFactory>

@property (nonatomic, strong) TyphoonComponentFactory *factory;

- (id<CCModule>)moduleForURL:(NSURL *)url thenChainUsingBlock:(ССModuleLinkBlock)block;

- (id<CCModule>)moduleForURL:(NSURL *)url;

- (id<CCModule>)moduleForStoryboard:(NSString *)storyboard
                         identifier:(NSString *)identifier;

- (id<CCModule>)moduleForViewControllerClass:(Class)clazz;



@end
