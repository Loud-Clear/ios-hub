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
#import "CCTableFormCell.h"
#import "CCEnvironmentFieldTextCell.h"


@interface CCEnvironmentFieldBool : CCEnvironmentFieldTextCell

@property (nonatomic, strong) UISwitch *switchControl;

@end
