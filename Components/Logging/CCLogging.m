////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <BugfenderSDK/BugfenderSDK.h>
#import "CCLogging.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "CCFileAndLineNumberFormatter.h"
#import "CCBugfenderLogger.h"


@implementation CCLogging

+ (void)setup
{
    [DDLog addLogger:[self ttyLogger]];
}

+ (void)setupWithBugfenderAppId:(NSString *)appId
{
    [self setup];

    if (appId.length > 0) {
        [Bugfender activateLogger:appId];
        [Bugfender enableUIEventLogging];

        [DDLog addLogger:[self bugfenderLogger]];
    }
}

+ (id<DDLogger>)ttyLogger
{
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    logger.colorsEnabled = YES;
    logger.logFormatter = [CCFileAndLineNumberFormatter new];
    return logger;
}

+ (id<DDLogger>)bugfenderLogger
{
    CCBugfenderLogger *logger = [CCBugfenderLogger sharedInstance];
    logger.logFormatter = [CCFileAndLineNumberFormatter new];
    return logger;
}


@end