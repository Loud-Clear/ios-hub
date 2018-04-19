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
#import <Typhoon/TyphoonTypeDescriptor.h>
#import "CCEnvironmentField.h"
#import "CCTableViewCellFactory.h"
#import "CCEnvironmentFieldTextCell.h"
#import "TyphoonTypeDescriptor.h"
#import "CCEnvironmentFieldBool.h"


@implementation CCEnvironmentField
{
    Class _cellClass;

}

- (CCTableViewCellFactory *)cellFactoryForCurrentItem
{
    return [CCTableViewCellFactory withCellClass:_cellClass reusable:YES];
}

- (void)setupWithType:(TyphoonTypeDescriptor *)descriptor
{
    if (descriptor.isPrimitive) {
        if (descriptor.primitiveType == TyphoonPrimitiveTypeBoolean) {
            _cellClass = [CCEnvironmentFieldBool class];
        }
    } else if (descriptor.typeBeingDescribed == [NSString class] || descriptor.typeBeingDescribed == [NSMutableString class]) {
        _cellClass = [CCEnvironmentFieldTextCell class];
    }

    NSAssert(_cellClass, @"Can't find cell for type: %@", descriptor);

}


@end
