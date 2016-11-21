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
#import "CCModuleFactory.h"

@interface CCGeneralWorkflow : NSObject <CCWorkflow>

@property (nonatomic, strong, readonly) id<CCModuleFactory> moduleFactory;

- (UIViewController *)newInitialViewController;

@end
