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

#import "CCURLWorkflow.h"
#import "UIViewController+CCWorkflow.h"
#import "CCMacroses.h"

@implementation CCURLWorkflow
{
    NSURL *_url;
    void(^_configureBlock)(id moduleInput);
}

@synthesize url=_url;

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)setInitialConfigureBlock:(void(^)(id moduleInput))block
{
    _configureBlock = block;
}

- (UIViewController *)newInitialViewController
{
    id<CCModule> module = [self.moduleFactory moduleForURL:_url thenChainUsingBlock:^id(id moduleInput) {
        SafetyCall(_configureBlock, moduleInput);
        return nil;
    }];
    UIViewController *viewController = [module asViewController];
    viewController.workflow = self;
    return viewController;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"url=%@", _url];
    [description appendString:@">"];
    return description;
}

@end
