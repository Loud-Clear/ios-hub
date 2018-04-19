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
#import "CCTableViewItem.h"

@class CCEnvironment;

@interface CCEnvironmentItem : CCTableViewItem

@property (nonatomic) CCEnvironment *environment;

@property (nonatomic) BOOL current;
@property (nonatomic) BOOL modified;

@end
