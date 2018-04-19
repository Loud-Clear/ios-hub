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

#import "CCEnvironmentFieldBool.h"
#import "ALView+PureLayout.h"
#import "CCEnvironmentField.h"
#import "CCTableFormManager.h"
#import "CCFormOutput.h"

@implementation CCEnvironmentFieldBool
{

}

- (void)createFieldView
{
    self.switchControl = [UISwitch new];
    [self.contentView addSubview:self.switchControl];

    [self.switchControl autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10];
    [self.switchControl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    [self.switchControl addTarget:self action:@selector(onSwitchChanged) forControlEvents:UIControlEventValueChanged];


    self.fieldView = self.switchControl;
}

- (void)setFieldValue:(id)value
{
    self.switchControl.on = [value boolValue];
}

- (void)onSwitchChanged
{
    self.item.value = @(self.switchControl.on);

    [self.output onSubmit];
}

@end
