////////////////////////////////////////////////////////////////////////////////
//
//  LOUDCLEAR
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of LoudClear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CCEnvironment;


@interface CCEnvironmentListViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) CCEnvironment *environment;

@end