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
#import "CCTableViewCell.h"
#import "CCMacroses.h"

@class CCEnvironmentItem;


@interface CCEnvironmentCell : CCTableViewCell

SUPPRESS_WARNING_INCOMPATIBLE_PROPERTY_TYPE
@property (nonatomic, strong) CCEnvironmentItem *item;
SUPPRESS_WARNING_END

@property (nonatomic, strong) UILabel *titleLabel;

@end