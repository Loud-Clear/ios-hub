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

#import "CCImageDiskCacheEntry.h"


@implementation CCImageDiskCacheEntry
{
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToEntry:other];
}

- (BOOL)isEqualToEntry:(CCImageDiskCacheEntry *)entry
{
    if (self == entry)
        return YES;
    if (entry == nil)
        return NO;
    if (self.dirUrl != entry.dirUrl && ![self.dirUrl isEqual:entry.dirUrl])
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.dirUrl hash];
    return hash;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

@end
