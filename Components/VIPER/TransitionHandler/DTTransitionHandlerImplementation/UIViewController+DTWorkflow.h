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

@protocol DTWorkflow;

@interface UIViewController (DTWorkflow)

@property (nonatomic, strong) id<DTWorkflow> workflow;

@end
