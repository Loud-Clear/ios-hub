////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 9.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSObject+CCBlockHandler.h"
#import "CCBlockHandler.h"


@implementation NSObject (CCBlockHandler)

- (dispatch_block_t)blockHandlerWithAction:(SEL)action
{
    return [CCBlockHandler withTarget:self action:action];
}

@end
