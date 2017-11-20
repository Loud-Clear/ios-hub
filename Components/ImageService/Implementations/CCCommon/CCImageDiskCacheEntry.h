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

@interface CCImageDiskCacheEntry : NSObject

@property (nonatomic) NSURL *dirUrl;
@property (nonatomic) NSDate *lastModifiedTime;
@property (nonatomic) unsigned long long sizeBytes;

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToEntry:(CCImageDiskCacheEntry *)entry;
- (NSUInteger)hash;

@end
