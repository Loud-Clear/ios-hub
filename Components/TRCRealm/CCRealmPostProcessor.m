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

#import <TyphoonRestClient/TyphoonRestClient.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import "CCRealmPostProcessor.h"
#import "_CCRealmSavePostProcessor.h"


@implementation CCRealmPostProcessor

+ (void)registerWithRestClient:(TyphoonRestClient *)restClient typhoonFactory:(TyphoonComponentFactory *)factory
{
    _CCRealmSavePostProcessor *savePostProcessor = [_CCRealmSavePostProcessor new];
    [factory inject:savePostProcessor];

    _CCRealmFetchPostProcessor *fetchPostProcessor = [_CCRealmFetchPostProcessor new];
    [factory inject:fetchPostProcessor];

    [restClient registerPostProcessor:savePostProcessor];
    [restClient registerPostProcessor:fetchPostProcessor];
}

@end
