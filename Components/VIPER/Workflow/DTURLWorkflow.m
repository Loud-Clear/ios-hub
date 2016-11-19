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

#import "DTURLWorkflow.h"
#import "UIViewController+DTWorkflow.h"
#import "DTMacroses.h"

@implementation DTURLWorkflow
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
    id<DTModule> module = [self.moduleFactory moduleForURL:_url];
    SafetyCall(_configureBlock, [module moduleInput]);
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
