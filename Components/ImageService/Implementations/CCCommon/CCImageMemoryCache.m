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
#import "CCImageServiceTag.h"


@interface MemoryCacheItem : NSObject
@property (nonatomic) UIImage *image;
@property (nonatomic) id<CCImageServiceTag> tag;
@end

@implementation MemoryCacheItem
@end

@implementation CCImageMemoryCache

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    if ((self = [super init])) {
        _memoryCache = [PINMemoryCache new];
        _memoryCache.ageLimit = 60*60; // 1 hour
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

    [_memoryCache objectForKey:[[url absoluteString] sha1] block:^(PINMemoryCache *cache, NSString *key, MemoryCacheItem *item)
    {
        if (item) {
            CCImageDbgLog(@"%@ loaded image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, item.tag);
        } else {
            CCImageDbgLog(@"%@ has NO image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, item.tag);
        }
        if (completion) {
            [self.completionQueue async:^{
                completion(item.image, item.tag);
            }];
        }
    }];
}

- (void)saveImage:(UIImage *)image forUrl:(NSURL *)url withTag:(id<CCImageServiceTag>)tag completion:(ImageMemoryCacheSaveImageBlock)completion
{
    NSParameterAssert(image);
    NSParameterAssert(url);

    MemoryCacheItem *item = [MemoryCacheItem new];
    item.tag = tag;
    item.image = image;

    @weakify(self);
    [_memoryCache setObject:(id)item forKey:[[url absoluteString] sha1] block:^(PINMemoryCache *cache, NSString *key, id object)
    {
        @strongify(self);

        if (object) {
            CCImageDbgLog(@"%@ saved to cache image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, tag);
        } else {
            CCImageDbgLog(@"%@ did NOT save to cache image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, tag);
        }

        if (completion) {
            [self.completionQueue async:^{
                completion(object != nil);
            }];
        }
    }];
}

@end
