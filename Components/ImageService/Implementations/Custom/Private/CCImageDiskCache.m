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

#import "CCImageDiskCache.h"
#import "NSString+SHA1.h"
#import "CCImageLog.h"
#import "CCDispatchUtils.h"

static NSString * const kCacheDirectory = @"CCImageDiskCache";
static NSString * const kErrorDomain = @"CCImageDiskCache";


@implementation CCImageDiskCache {
    CCDispatchQueue *_workQueue;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id) init
{
    if ((self = [super init])) {
        _workQueue = [CCDispatchQueue lowPriorityQueue];
        _completionQueue = [CCDispatchQueue mainQueue];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void) getModificationDateForImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageModificationDateBlock)completion
{
    NSParameterAssert(url);

    [_workQueue async:^
    {
        NSString *hash = [[self class] hashForUrl:url];
        NSURL *baseDirUrl = [[self class] baseUrlPathForHash:hash];
        NSURL *imageFileUrl = [[self class] urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];

        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[imageFileUrl path] isDirectory:nil];
        if (!exists) {
            CCImageDbgLog(@"%@ has NO image for url %@.", NSStringFromClass([self class]), url);
            if (completion) {
                [_completionQueue async:^{
                    completion(nil);
                }];
            }
            return;
        }

        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[imageFileUrl path] error:nil];
        NSDate *modificationDate = attributes[NSFileModificationDate];

        CCImageDbgLog(@"%@ has image for url \"%@\" with modification date %@.", NSStringFromClass([self class]), url, modificationDate);

        if (completion) {
            [_completionQueue async:^{
                completion(modificationDate);
            }];
        }
    }];
}

- (NSURL *)localUrlForRemoteUrl:(NSURL *)remoteUrl
{
    NSString *hash = [[self class] hashForUrl:remoteUrl];
    NSURL *baseDirUrl = [[self class] baseUrlPathForHash:hash];
    return [[self class] urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];
}

- (void) getImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageBlock)completion
{
    NSParameterAssert(url);

    [_workQueue async:^
    {
        UIImage *image = nil;
        NSError *error = nil;

        NSString *hash = [[self class] hashForUrl:url];
        NSURL *baseDirUrl = [[self class] baseUrlPathForHash:hash];
        NSURL *imageFileUrl = [[self class] urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];

        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl options:0 error:&error];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
            if (!image) {
                error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Can't decode image"}];
            }
        }

        if (image) {
            CCImageDbgLog(@"%@ loaded image for url \"%@\".", NSStringFromClass([self class]), url);
        } else {
            CCImageDbgLog(@"%@ did NOT load image for url \"%@\" because of error: %@.", NSStringFromClass([self class]), url, error);
        }

        if (completion) {
            [_completionQueue async:^{
                completion(image, error);
            }];
        }
    }];
}

- (void)saveImageData:(NSData *)data forUrl:(NSURL *)url withLastModificationDate:(NSDate *)modificationDate completion:(CCImageDiskCacheSaveImageBlock)completion
{
    NSParameterAssert(data);
    NSParameterAssert(url);

    [_workQueue async:^
    {
        NSError *error = nil;
        BOOL saved = [self saveImageData:data forUrl:url withModificationDate:modificationDate error:&error];

        #if IMAGE_DBG_LOG_ENABLED
        NSString *withModificationDateText = modificationDate ? [NSString stringWithFormat:@" with modification date %@", modificationDate] : @"";
        #endif

        if (saved) {
            CCImageDbgLog(@"%@ saved to cache image for url \"%@\"%@.", NSStringFromClass([self class]), url, withModificationDateText);
        } else {
            CCImageDbgLog(@"%@ did NOT save to cache image for url \"%@\"%@.", NSStringFromClass([self class]), url, withModificationDateText);
        }

        if (completion) {
            [_completionQueue async:^{
                completion(error);
            }];
        }
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

+ (NSURL *) cachesDirectoryUrl
{
    NSArray *cachesUrls = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    return cachesUrls[0];
}

+ (NSURL *) baseUrlPathForHash:(NSString *)hash
{
    NSAssert([hash length] >= 2, nil);

    NSURL *cachesUrl = [self cachesDirectoryUrl];
    NSURL *cacheDirUrl = [cachesUrl URLByAppendingPathComponent:kCacheDirectory];

    NSString *dir1 = [hash substringWithRange:NSMakeRange(0, 1)];
    NSString *dir2 = [hash substringWithRange:NSMakeRange(1, 1)];

    NSURL *result = [[cacheDirUrl URLByAppendingPathComponent:dir1] URLByAppendingPathComponent:dir2];

    return result;
}

+ (BOOL) makeDirectoryForUrlIfNeeded:(NSURL *)url error:(NSError **)errorPtr
{
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:errorPtr];
    return result;
}

+ (NSURL *) urlPathOfImageDataFileForHash:(NSString *)hash withBaseDirUrl:(NSURL *)baseDirUrl
{
    NSString *filename = hash;
    NSURL *result = [baseDirUrl URLByAppendingPathComponent:filename isDirectory:NO];
    return result;
}

+ (NSString *) hashForUrl:(NSURL *)url
{
    NSString *absoluteString = [url absoluteString];
    NSString *hash = [absoluteString sha1];
    return hash;
}

- (BOOL) saveImageData:(NSData *)data forUrl:(NSURL *)url withModificationDate:(NSDate *)modificationDate error:(NSError **)error
{
    NSString *hash = [[self class] hashForUrl:url];
    NSURL *baseDirUrl = [[self class] baseUrlPathForHash:hash];
    NSURL *imageFileUrl = [[self class] urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];

    if (![[self class] makeDirectoryForUrlIfNeeded:baseDirUrl error:error]) {
        return NO;
    }

    if (![data writeToURL:imageFileUrl options:NSDataWritingAtomic error:error]) {
        return NO;
    }

    if (modificationDate) {
        NSDictionary *attributes = @{ NSFileModificationDate : modificationDate };

        if (![[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[imageFileUrl path] error:error]) {
            return NO;
        }
    }

    return YES;
}

@end
