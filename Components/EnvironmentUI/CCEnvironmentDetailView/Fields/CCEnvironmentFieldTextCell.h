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
#import "CCMacroses.h"


@class CCEnvironmentField;


@interface CCEnvironmentFieldTextCell : CCTableFormCell

SUPPRESS_WARNING_INCOMPATIBLE_PROPERTY_TYPE
@property (nonatomic, strong) CCEnvironmentField *item;
SUPPRESS_WARNING_END


@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *fieldView;


- (void)createFieldView;

- (void)setFieldValue:(id)value;
@end