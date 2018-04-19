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

#import <Foundation/Foundation.h>
#import "CCTableFormManager.h"

@class CCEnvironment;


@interface CCEnvironmentDetailViewController : UIViewController <CCTableFormManagerDelegate>

@property (nonatomic) CCEnvironment *environment;

@end
