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

#import "CCImageServiceTagModificationDate.h"

@implementation CCImageServiceTagModificationDate

+ (NSString *)tagIdentifier
{
    return @"modification_date";
}

+ (id<CCImageServiceTag>)tagFromData:(NSData *)data
{
    return [self objectWithData:data];
}

+ (NSData *)tagToData:(id<CCImageServiceTag>)tag
{
    return [self dataWithRootObject:tag];
}

- (instancetype)initFromData:(NSData *)data
{
    if (!(self = [super init])) {
        return nil;
    }

    _modificationDate = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return self;
}

- (NSComparisonResult)compare:(CCImageServiceTagModificationDate *)otherTag
{
#if DEBUG
    if (![otherTag isKindOfClass:[CCImageServiceTagModificationDate class]]) {
        NSAssert(NO, nil);
    }
#endif

    if (otherTag.modificationDate == nil) {
        NSAssert(NO, nil);
        return NSOrderedDescending;
    };

    return [_modificationDate compare:otherTag.modificationDate];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _modificationDate];
}

@end
