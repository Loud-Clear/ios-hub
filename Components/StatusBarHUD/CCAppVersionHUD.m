////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCAppVersionHUD.h"
#import "CCMacroses.h"
#import "CCStatusBarHUD.h"


@implementation CCAppVersionHUD
{
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)sharedHUD
{
    CC_IMPLEMENT_SHARED_SINGLETON(CCAppVersionHUD)
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.position = NSTextAlignmentLeft;

    return self;
}

- (void)setup
{
    [self update];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)setPosition:(NSTextAlignment)position
{
    _position = position;

    [self update];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)update
{
    if (_position == NSTextAlignmentLeft) {
        [CCStatusBarHUD sharedHUD].statusLabelLeft.text = [self getVersionString];
    } else if (_position == NSTextAlignmentRight) {
        [CCStatusBarHUD sharedHUD].statusLabelRight.text = [self getVersionString];
    }
}

- (NSString *)getVersionString
{
    NSString *versionString = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    NSString *buildString = NSBundle.mainBundle.infoDictionary[(NSString *)kCFBundleVersionKey];

    NSMutableArray<NSString *> *comps = [NSMutableArray new];
    if (versionString.length) {
        [comps addObject:versionString];
    }
    if (buildString.length) {
        [comps addObject:buildString];
    }

    NSString *fullVersionString = [comps componentsJoinedByString:@"."];
    fullVersionString = [@"v" stringByAppendingString:fullVersionString];
    return fullVersionString;
}

@end
