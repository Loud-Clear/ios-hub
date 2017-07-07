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

#import "CCEnvironment.h"
#import "CCTableViewItem.h"
#import "CCEnvironmentItem.h"
#import "CCTableViewCellFactory.h"
#import "CCEnvironmentCell.h"


@implementation CCEnvironmentItem

- (CCTableViewCellFactory *)cellFactoryForCurrentItem
{
    return [CCTableViewCellFactory withCellClass:[CCEnvironmentCell class] reusable:YES];
}

@end