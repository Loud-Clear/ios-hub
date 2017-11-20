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

#import "CCImageServiceTagAvatarVersion.h"


@implementation CCImageServiceTagAvatarVersion

+ (NSString *)tagIdentifier
{
    return @"avatar_version";
}

+ (id<CCImageServiceTag>)tagFromData:(NSData *)data
{
    return [self objectWithData:data];
}

+ (NSData *)tagToData:(id<CCImageServiceTag>)tag
{
    return [self dataWithRootObject:tag];
}

- (NSComparisonResult)compare:(CCImageServiceTagAvatarVersion *)otherTag
{
#if DEBUG
    if (![otherTag isKindOfClass:[CCImageServiceTagAvatarVersion class]]) {
        NSAssert(NO, nil);
    }
#endif

    if (otherTag.avatarVersion == nil) {
        NSAssert(NO, nil);
        return NSOrderedDescending;
    };

    return [_avatarVersion compare:otherTag.avatarVersion];
}

- (NSString *)description
{
    return [_avatarVersion stringValue];
}

@end
