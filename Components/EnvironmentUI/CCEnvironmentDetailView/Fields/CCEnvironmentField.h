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
#import "CCTableFormItem.h"

@class CCEnvironment;
@class TyphoonTypeDescriptor;


@interface CCEnvironmentField : CCTableFormItem

@property (nonatomic, strong) CCEnvironment *environment;

- (void)setupWithType:(TyphoonTypeDescriptor *)descriptor;

@end