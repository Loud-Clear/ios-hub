////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 3.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCObject.h"


@implementation CCObject

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }

    [self setup];

    return self;
}

- (void)setup
{

}

@end
