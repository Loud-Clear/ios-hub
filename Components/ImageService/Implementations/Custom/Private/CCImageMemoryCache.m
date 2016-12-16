////////////////////////////////////////////////////////////////////////////////
//
//  VAMPR
//  Copyright 2016 Vampr Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Vampr. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCImageMemoryCache.h"
#import "PINCache.h"
#import "CCImageLog.h"
#import "CCDispatchUtils.h"
#import "NSString+SHA1.h"
#import "CCMacroses.h"

@interface MemoryCacheItem : NSObject
@property (nonatomic) UIImage *image;
@property (nonatomic) NSDate *lastModificationDate;
@end

@implementation MemoryCacheItem
@end

@implementation CCImageMemoryCache {
    PINMemoryCache *memoryCache;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id) init
{
    if ((self = [super init])) {
        memoryCache = [PINMemoryCache new];
        memoryCache.ageLimit = 60*60; // 1 hour
        self.completionQueue = [CCDispatchQueue mainQueue];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void) getImageAtUrl:(NSURL *)url completion:(ImageMemoryCacheGetImageBlock)completion
{
    NSParameterAssert(url);

    [memoryCache objectForKey:[[url absoluteString] sha1] block:^(PINMemoryCache *cache, NSString *key, MemoryCacheItem *item)
    {
        if (item) {
            CCImageDbgLog(@"%@ loaded image for url \"%@\".", NSStringFromClass([self class]), url);
        } else {
            CCImageDbgLog(@"%@ has NO image for url \"%@\".", NSStringFromClass([self class]), url);
        }
        if (completion) {
            [self.completionQueue async:^{
                completion(item.image, item.lastModificationDate);
            }];
        }
    }];
}

- (void) saveImage:(UIImage *)image forUrl:(NSURL *)url withLastModificationDate:(NSDate *)lastModificationDate completion:(ImageMemoryCacheSaveImageBlock)completion
{
    NSParameterAssert(image);
    NSParameterAssert(url);

    MemoryCacheItem *item = [MemoryCacheItem new];
    item.lastModificationDate = lastModificationDate;
    item.image = image;

    @weakify(self);
    [memoryCache setObject:(id)item forKey:[[url absoluteString] sha1] block:^(PINMemoryCache *cache, NSString *key, id object)
    {
        @strongify(self);

        #if IMAGE_DBG_LOG_ENABLED
        NSString *withModificationDateText = lastModificationDate ? [NSString stringWithFormat:@" with modification date %@", lastModificationDate] : @"";
        #endif

        if (object) {
            CCImageDbgLog(@"%@ saved to cache image for url \"%@\"%@.", NSStringFromClass([self class]), url, withModificationDateText);
        } else {
            CCImageDbgLog(@"%@ did NOT save to cache image for url \"%@\"%@", NSStringFromClass([self class]), url, withModificationDateText);
        }

        if (completion) {
            [self.completionQueue async:^{
                completion(object ? YES : NO);
            }];
        }
    }];
}

@end
