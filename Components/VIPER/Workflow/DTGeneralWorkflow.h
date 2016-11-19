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

#import "DTWorkflow.h"
#import "DTModuleFactory.h"

@interface DTGeneralWorkflow : NSObject <DTWorkflow>

@property (nonatomic, strong, readonly) id<DTModuleFactory> moduleFactory;

- (UIViewController *)newInitialViewController;

@end
