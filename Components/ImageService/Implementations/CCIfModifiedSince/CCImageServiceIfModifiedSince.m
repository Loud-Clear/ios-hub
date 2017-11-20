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

#import "CCImageService.h"
#import "CCImageServiceIfModifiedSince.h"
#import "CCImageDownloader.h"
#import "CCImageDiskCache.h"
#import "CCImageMemoryCache.h"
#import "CCImageGetContext.h"
#import "CCImageServiceTag.h"
#import "CCImageLog.h"
#import "CCDispatchUtils.h"
#import "CCMacroses.h"
#import "CCImageServiceTagModificationDate.h"
#import "NSError+FSErrors.h"


@implementation CCImageServiceIfModifiedSince {
    CCImageDownloader *_imageDownloader;
    CCImageDiskCache *_diskCache;
    CCImageMemoryCache *_memoryCache;
    NSMutableDictionary<NSString *, CCImageGetContext *> *_contextsMap;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageDownloader = [CCImageDownloader new];
    _diskCache = [[CCImageDiskCache alloc] initWithTagClass:[CCImageServiceTagModificationDate class]];
    _memoryCache = [CCImageMemoryCache new];
    _contextsMap = [NSMutableDictionary new];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)getImageForUrl:(NSURL *)url tag:(id<CCImageServiceTag>)tag options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion
{
    NSParameterAssert(url);

    if (!completion) {
        return;
    }

    if (![NSThread isMainThread]) {
        NSAssert(NO, @"Call only from main thread");
        return;
    }

    NSString *urlString = [url absoluteString];

    CCImageGetContext *context = _contextsMap[urlString];

    BOOL hasContext = (context != nil);

    if (!context) {
        CCImageDbgLog(@"Creating new context for image for url '%@'.", url);
        context = [CCImageGetContext new];
        context.urlString = urlString;
        [context addCompletionBlock:^(UIImage *image, NSError *error)
        {
            CCImageDbgLog(@"Removing context for %@", urlString);
            [_contextsMap removeObjectForKey:urlString];
        }];
        _contextsMap[urlString] = context;
    }

    [context addCompletionBlock:completion];

    if (hasContext) {
        CCImageDbgLog(@"Already has context for '%@'.", urlString);
        return;
    }

    CCImageDbgLog(@"Looking in memory cache image for url '%@'.", url);

    [_memoryCache getImageAtUrl:url completion:^(UIImage *memoryImage, CCImageServiceTagModificationDate *memoryTag)
    {
        if (memoryImage)
        {
            CCImageDbgLog(@"Loaded image for url '%@' from memory cache.", url);

            [context callCompletionsWithImage:memoryImage error:nil];
            return;
        }

        CCImageDbgLog(@"Memory cache has no image, getting tag from disk cache for image for url '%@'.", url);

        [_diskCache getTagForImageAtUrl:url completion:^(CCImageServiceTagModificationDate *diskTag)
        {
            CCImageDbgLog(@"Downloading image for url '%@' with modificationDate '%@'", url, diskTag.modificationDate);

            [_imageDownloader getImageIfNeededAtUrl:url withCurrentModificationDate:diskTag.modificationDate completion:^(BOOL changed, NSData *imageData, NSDate *newModificationDate, NSError *downloadError)
            {
                if (downloadError)
                {
                    CCImageDbgLog(@"Can't download image for url '%@' because of error '%@'", url, downloadError);

                    [context callCompletionsWithImage:nil error:downloadError];
                    return;
                }

                if (changed)
                {
                    CCImageDbgLog(@"Image did change on server, saving it, newModificationDate='%@' url='%@'", newModificationDate, url);

                    [[CCDispatchQueue lowPriorityConcurrentQueue] async:^
                    {
                        UIImage *image = [UIImage imageWithData:imageData];
                        if (!image) {
                            DDLogError(@"Can't decode image loaded from network for url '%@'.", url);
                            [context callCompletionsWithImage:nil error:[NSError errorWithDescription:@"Can't decode image"]];
                            return;
                        }

                        CCImageDbgLog(@"Loaded image for url '%@' from network.", url);

                        [context callCompletionsWithImage:image error:nil];

                        CCImageServiceTagModificationDate *newTag = [CCImageServiceTagModificationDate new];
                        newTag.modificationDate = newModificationDate;

                        [_memoryCache saveImage:image forUrl:url withTag:newTag completion:nil];
                        [_diskCache saveImageData:imageData forUrl:url withTag:newTag completion:nil];
                    }];
                }
                else
                {
                    CCImageDbgLog(@"Image didn't change on server, getting from cache, url='%@'", url);

                    [_diskCache getImageAtUrl:url completion:^(UIImage *diskImage, NSError *error)
                    {
                        if (!diskImage) {
                            DDLogError(@"Can't load image for url '%@' from disk cache.", url);
                            [context callCompletionsWithImage:nil error:error];
                            return;
                        }

                        CCImageDbgLog(@"Loaded image for url %@ from disk.", url);

                        [context callCompletionsWithImage:diskImage error:nil];

                        [_memoryCache saveImage:diskImage forUrl:url withTag:diskTag completion:nil];
                    }];
                }
            }];
        }];
    }];
}

- (void)getImagePathForUrl:(NSURL *)remoteUrl options:(CCGetImageOptions)options completion:(CCImageServiceGetImagePathBlock)completion
{
    [self getImageForUrl:remoteUrl tag:nil options:options completion:^(UIImage *image, NSError *error) {
        NSString *localPath = nil;
        if (image) {
            localPath = [[_diskCache localUrlForRemoteUrl:remoteUrl] path];
        }
        SafetyCall(completion, localPath, error);
    }];
}

@end
