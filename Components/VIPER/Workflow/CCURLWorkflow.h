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

#import "CCWorkflow.h"
#import "CCGeneralWorkflow.h"


@interface CCURLWorkflow : CCGeneralWorkflow <CCWorkflow>

@property (nonatomic, strong, readonly) NSURL* url;

- (instancetype)initWithURL:(NSURL *)url;

- (void)setInitialConfigureBlock:(void(^)(id moduleInput))block;

@end
