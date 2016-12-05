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
#import "CCImageServiceCustomImpl.h"
#import "CCImageDownloader.h"
#import "CCImageDiskCache.h"
#import "CCImageMemoryCache.h"
#import "CCImageGetContext.h"
#import "CCImageLog.h"
#import "CCDispatchUtils.h"

@implementation CCImageServiceCustomImpl {
    CCImageDownloader *_imageDownloader;
    CCImageDiskCache *_diskCache;
    CCImageMemoryCache *_memoryCache;
    NSMutableDictionary<NSString *, CCImageGetContext *> *_contextsMap;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id) init
{
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    _imageDownloader = [CCImageDownloader new];
    _diskCache = [CCImageDiskCache new];
    _memoryCache = [CCImageMemoryCache new];
    _contextsMap = [NSMutableDictionary new];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void) getImageForUrl:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion
{
    NSParameterAssert(url);
    
    if (!completion) {
        return;
    }

    if (![NSThread isMainThread]) {
        NSAssert(NO, @"Call only from main thread");
    }

    NSString *urlString = [url absoluteString];

    CCImageGetContext *context = _contextsMap[urlString];

    BOOL hasContext = (context != nil);

    if (!context) {
        context = [CCImageGetContext contextWithUrl:urlString];
        _contextsMap[urlString] = context;
    }

    [context addCompletionBlock:completion];

    if (hasContext) {
        CCImageDbgLog(@"Already has context for %@", urlString);
        return;
    }

    [context taskStarted];

    [_memoryCache getImageAtUrl:url completion:^(UIImage *memoryImage, NSDate *lastModificationDate)
    {
        if (memoryImage)
        {
            DDLogDebug(@"Loaded image for url %@ from memory cache.", url);

            [context callCompletionsWithImage:memoryImage error:nil];
            [context taskFinished];
            return;
        }

        [context taskStarted];

        [_diskCache getModificationDateForImageAtUrl:url completion:^(NSDate *modificationDate)
        {
            [context taskStarted];

            [_imageDownloader getImageIfNeededAtUrl:url withCurrentModificationDate:modificationDate completion:^(BOOL changed, NSData *imageData, NSDate *newModificationDate, NSError *downloadError)
            {
                if (downloadError)
                {
                    completion(nil, downloadError);
                    [context callCompletionsWithImage:nil error:downloadError];
                    [context taskFinished];
                    return;
                }

                if (changed)
                {
                    [context taskStarted];

                    [[CCDispatchQueue lowPriorityQueue] async:^
                    {
                        UIImage *image = [UIImage imageWithData:imageData];
                        if (!image) {
                            [context taskFinished];
                            return;
                        }

                        DDLogDebug(@"Loaded image for url %@ from internet.", url);

                        context.gotImageFromNetwork = YES;
                        [context callCompletionsWithImage:image error:nil];

                        [_memoryCache saveImage:image forUrl:url withLastModificationDate:newModificationDate completion:nil];
                        [_diskCache saveImageData:imageData forUrl:url withLastModificationDate:newModificationDate completion:nil];

                        [context taskFinished];
                    }];
                }

                [context taskFinished];
            }];

            if (modificationDate)
            {
                [context taskStarted];

                [_diskCache getImageAtUrl:url completion:^(UIImage *diskImage, NSError *error)
                {
                    if (diskImage && !context.gotImageFromNetwork)
                    {
                        DDLogDebug(@"Loaded image for url %@ from disk.", url);

                        [context callCompletionsWithImage:diskImage error:nil];

                        [_memoryCache saveImage:diskImage forUrl:url withLastModificationDate:modificationDate completion:nil];
                    }
                    [context taskFinished];
                }];
            }

            [context taskFinished];
        }];

        [context taskFinished];
    }];

    [context notifyWhenDone:^{
        CCImageDbgLog(@"Removing context for %@", urlString);
        [_contextsMap removeObjectForKey:urlString];
    }];
}

@end
