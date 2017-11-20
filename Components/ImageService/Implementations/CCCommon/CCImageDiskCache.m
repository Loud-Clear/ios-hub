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

#import <ComponentsHub/NSError+CCTableFormManager.h>
#import "CCImageDiskCache.h"
#import "NSString+SHA1.h"
#import "CCImageLog.h"
#import "CCDispatchUtils.h"
#import "CCImageServiceTag.h"
#import "CCImageDiskCacheEntry.h"


static NSString *const kCacheDirectory = @"CCImageDiskCache";
static NSString *const kErrorDomain = @"CCImageDiskCache";
static NSString *const kTagExtension = @"tag";
static NSString *const kImageExtension = @"image";


@implementation CCImageDiskCache
{
    CCDispatchQueue *_workQueue;
    Class<CCImageServiceTag> _tagClass;
    NSMutableArray<CCImageDiskCacheEntry *> *_cacheIndex;
    CCDispatchQueue *_cacheIndexQueue;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    NSAssert(NO, @"Use initWithTagClass:");
    return nil;
}

- (instancetype)initWithTagClass:(Class<CCImageServiceTag>)tagClass
{
    if (!(self = [super init])) {
        return nil;
    }

    _tagClass = tagClass;

    [self setup];

    return self;
}

- (void)setup
{
    self.maxCacheSizeBytes = 100*1024*1024;

    _workQueue = [CCDispatchQueue lowPrioritySerialQueue];
    _completionQueue = [CCDispatchQueue mainQueue];
    _cacheIndex = [NSMutableArray new];
    _cacheIndexQueue = [CCDispatchQueue backgroundPrioritySerialQueue];

    [_cacheIndexQueue async:^{
        [self updateCacheIndex];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)getImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageBlock)completion
{
    NSParameterAssert(url);

    [_workQueue async:^{
        UIImage *image = [self getImageAtUrl:url];

        if (image) {
            CCImageDbgLog(@"%@ read image for url \"%@\".", NSStringFromClass([self class]), url);
        } else {
            CCImageDbgLog(@"%@ did NOT read image for url \"%@\".", NSStringFromClass([self class]), url);
        }

        if (completion) {
            [_completionQueue async:^{
                completion(image, nil);
            }];
        }
    }];
}

- (NSURL *)localUrlForRemoteUrl:(NSURL *)remoteUrl
{
    NSString *hash = [self hashForUrl:remoteUrl];
    NSURL *baseDirUrl = [self baseUrlPathForHash:hash];
    return [self urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];
}

- (void)getTagForImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageTagBlock)completion
{
    NSParameterAssert(url);

    [_workQueue async:^{

        id<CCImageServiceTag> tag = [self getTagForImageAtUrl:url];

        if (tag) {
            CCImageDbgLog(@"%@ read tag for url \"%@\".", NSStringFromClass([self class]), url);
        } else {
            CCImageDbgLog(@"%@ did NOT read tag for url \"%@\".", NSStringFromClass([self class]), url);
        }

        if (completion) {
            [_completionQueue async:^{
                completion(tag);
            }];
        }
    }];
}

- (void)saveImageData:(NSData *)data forUrl:(NSURL *)url withTag:(id<CCImageServiceTag>)tag completion:(CCImageDiskCacheSaveImageBlock)completion;
{
    NSParameterAssert(data);
    NSParameterAssert(url);

    [_workQueue async:^{
        NSError *error = nil;
        BOOL saved = [self _saveImageData:data forUrl:url withTag:tag error:&error];

        if (saved) {
            CCImageDbgLog(@"%@ saved to cache image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, tag);
        } else {
            CCImageDbgLog(@"%@ did NOT save to cache image for url '%@' with tag '%@'.", NSStringFromClass([self class]), url, tag);
        }

        if (completion) {
            [_completionQueue async:^{
                completion(error);
            }];
        }
    }];
}

- (void)clearCache
{
    [_cacheIndexQueue async:^{
        [_cacheIndex removeAllObjects];

        NSURL *cacheDir = [self workingDirectoryUrl];
        NSError *error = nil;
        [NSFileManager.defaultManager removeItemAtURL:cacheDir error:&error];
        if (error) {
            DDLogError(@"Can't clear cache at dir '%@': %@.", cacheDir, error);
        } else {
            DDLogInfo(@"Cleared cache dir '%@'.", cacheDir);
        }
    }];
}

- (void)trimCacheIfNeeded
{
    [_cacheIndexQueue async:^{
        [self _trimCacheIfNeeded];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (NSURL *)workingDirectoryUrl
{
    NSArray *cachesDirsUrls = [NSFileManager.defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cachesDirUrl = [cachesDirsUrls firstObject];
    NSURL *workingDirUrl = [cachesDirUrl URLByAppendingPathComponent:kCacheDirectory];
    workingDirUrl = [workingDirUrl URLByAppendingPathComponent:[_tagClass tagIdentifier]];
    return workingDirUrl;
}


- (NSURL *)baseLocalUrlPathForUrl:(NSURL *)url
{
    NSString *hash = [self hashForUrl:url];
    NSURL *result = [self baseUrlPathForHash:hash];
    return result;
}

- (NSURL *)baseUrlPathForHash:(NSString *)hash
{
    NSAssert([hash length] >= 2, nil);

    NSURL *workingDirUrl = [self workingDirectoryUrl];
    NSString *hash2Symbols = [hash substringWithRange:NSMakeRange(0, 2)];
    NSURL *result = [[workingDirUrl URLByAppendingPathComponent:hash2Symbols] URLByAppendingPathComponent:hash];
    return result;
}

- (BOOL)makeDirectoryForUrlIfNeeded:(NSURL *)url error:(NSError **)errorPtr
{
    BOOL result = [NSFileManager.defaultManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:errorPtr];
    return result;
}

- (NSURL *)urlPathOfImageDataFileForHash:(NSString *)hash withBaseDirUrl:(NSURL *)baseDirUrl
{
    NSURL *result = [baseDirUrl URLByAppendingPathComponent:kImageExtension isDirectory:NO];
    return result;
}

- (NSURL *)urlPathOfTagFileForHash:(NSString *)hash withBaseDirUrl:(NSURL *)baseDirUrl
{
    NSURL *result = [baseDirUrl URLByAppendingPathComponent:kTagExtension isDirectory:NO];
    return result;
}

- (NSString *)hashForUrl:(NSURL *)url
{
    NSString *absoluteString = [url absoluteString];
    NSString *hash = [absoluteString sha1];
    return hash;
}

- (BOOL)_saveImageData:(NSData *)data forUrl:(NSURL *)url withTag:(id<CCImageServiceTag>)tag error:(NSError **)error
{
    NSString *hash = [self hashForUrl:url];
    NSURL *baseDirUrl = [self baseUrlPathForHash:hash];
    NSURL *imageFileUrl = [self urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];

    if (![self makeDirectoryForUrlIfNeeded:baseDirUrl error:error]) {
        return NO;
    }

    if (![data writeToURL:imageFileUrl options:NSDataWritingAtomic error:error]) {
        return NO;
    }

    if (tag) {
        NSURL *tagFileUrl = [self urlPathOfTagFileForHash:hash withBaseDirUrl:baseDirUrl];

        NSData *tagData = [_tagClass tagToData:tag];

        if (![tagData writeToURL:tagFileUrl options:NSDataWritingAtomic error:error]) {
            [NSFileManager.defaultManager removeItemAtURL:imageFileUrl error:nil];
            return NO;
        }
    }

    [_cacheIndexQueue async:^{
        CCImageDiskCacheEntry *entry = [self getCacheEntryWithDirUrlAndPlaceToTop:baseDirUrl];
        entry.lastModifiedTime = [NSDate date];
        entry.sizeBytes = [data length];
        [self _trimCacheIfNeeded];
    }];

    return YES;
}

- (CCImageDiskCacheEntry *)getCacheEntryWithDirUrlAndPlaceToTop:(NSURL *)baseDirUrl
{
    CCImageDiskCacheEntry *entry = [CCImageDiskCacheEntry new];
    entry.dirUrl = baseDirUrl;
    if ([_cacheIndex containsObject:entry]) {
        NSUInteger index = [_cacheIndex indexOfObject:entry];
        entry = _cacheIndex[index];
        if (index != 0) {
            [_cacheIndex removeObjectAtIndex:index];
            [_cacheIndex insertObject:entry atIndex:0];
        }
    } else {
        [_cacheIndex insertObject:entry atIndex:0];
    }

    return entry;
}

- (UIImage *)getImageAtUrl:(NSURL *)url
{
    NSString *hash = [self hashForUrl:url];
    NSURL *baseDirUrl = [self baseUrlPathForHash:hash];
    NSURL *imageFileUrl = [self urlPathOfImageDataFileForHash:hash withBaseDirUrl:baseDirUrl];
    NSError *error = nil;

    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl options:0 error:&error];
    if (!imageData) {
        return nil;
    }

    UIImage *image = nil;
    @try {
        image = [UIImage imageWithData:imageData];
    }
    @catch(id) {
    }

    if (!image) {
        [_cacheIndexQueue async:^{
            [self deleteImageAtBaseDirUrl:baseDirUrl];
        }];
    } else {
        [_cacheIndexQueue async:^{
            [self updateCacheIndexAndTouchFileForImageAtUrl:url size:imageData.length];
        }];
    }

    return image;
}

- (id<CCImageServiceTag>)getTagForImageAtUrl:(NSURL *)url
{
    NSString *hash = [self hashForUrl:url];
    NSURL *baseDirUrl = [self baseUrlPathForHash:hash];
    NSURL *tagFileUrl = [self urlPathOfTagFileForHash:hash withBaseDirUrl:baseDirUrl];
    NSError *error = nil;

    NSData *tagData = [NSData dataWithContentsOfURL:tagFileUrl options:0 error:&error];
    if (!tagData) {
        return nil;
    }
    id<CCImageServiceTag> tag = [_tagClass tagFromData:tagData];
    return tag;
}

- (NSError *)errorWithFormat:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    NSString *string = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);

    return [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: string}];
}

- (void)updateCacheIndex
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator =
            [fileManager enumeratorAtURL:[self workingDirectoryUrl]
              includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey]
                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                            errorHandler:^BOOL(NSURL *url, NSError *error) {
                                if (error) {
                                    CCImageDbgLog(@"Error reading '%@': %@.", url, error);
                                    return NO;
                                }
                                return YES;
                            }];

    unsigned long long totalSize = 0;
    NSURL *lastDir = nil;

    for (NSURL *url in enumerator)
    {
        NSNumber *isDirectory;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        if ([isDirectory boolValue]) {
            lastDir = url;
            continue;
        }

        NSString *filename = nil;
        [url getResourceValue:&filename forKey:NSURLNameKey error:nil];

        if (![filename hasSuffix:kImageExtension]) {
            continue;
        }

        CCImageDiskCacheEntry *entry = [CCImageDiskCacheEntry new];
        entry.dirUrl = lastDir;
        if ([_cacheIndex containsObject:entry]) {
            continue;
        }

        NSDate *modificationDate = nil;
        [url getResourceValue:&modificationDate forKey:NSURLContentModificationDateKey error:nil];
        entry.lastModifiedTime = modificationDate;

        NSNumber *fileSize = nil;
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
        entry.sizeBytes = [fileSize unsignedLongLongValue];

        [_cacheIndex addObject:entry];

        totalSize += entry.sizeBytes;
    }

    [self sortCacheIndex];

    DDLogInfo(@"Built cache index: %@ items, total size %.3fMB", @(_cacheIndex.count), totalSize / (1024.0 * 1024.0));
}

- (void)deleteCacheEntryFromDisk:(CCImageDiskCacheEntry *)entry
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:entry.dirUrl error:&error];
    if (error) {
        DDLogWarn(@"Can't remove cache item at '%@': %@.", entry.dirUrl, error);
    }
}

- (void)deleteImageAtBaseDirUrl:(NSURL *)baseDirUrl
{
    CCImageDiskCacheEntry *foundEntry = nil;
    for (CCImageDiskCacheEntry *entry in _cacheIndex) {
        if ([entry.dirUrl isEqual:baseDirUrl]) {
            foundEntry = entry;
            break;
        }
    }

    if (!foundEntry) {
        return;
    }

    [self deleteCacheEntryFromDisk:foundEntry];
    [_cacheIndex removeObject:foundEntry];
}

- (void)sortCacheIndex
{
    [_cacheIndex sortUsingComparator:^NSComparisonResult(CCImageDiskCacheEntry *entry1, CCImageDiskCacheEntry *entry2) {
        if (!entry1) {
            return NSOrderedAscending;
        }
        if (!entry2) {
            return NSOrderedDescending;
        }
        return [entry1.lastModifiedTime compare:entry2.lastModifiedTime];
    }];
}

- (void)_trimCacheIfNeeded
{
    unsigned long long totalSize = 0;

    for (CCImageDiskCacheEntry *entry in _cacheIndex) {
        totalSize += entry.sizeBytes;
    }

    unsigned long long totalSizeBeforeCleanUp = totalSize;

    while (totalSize > self.maxCacheSizeBytes) {
        CCImageDiskCacheEntry *entry = [_cacheIndex lastObject];
        if (!entry) {
            break;
        }

        [self deleteCacheEntryFromDisk:entry];
        [_cacheIndex removeObject:entry];

        totalSize -= entry.sizeBytes;
    }

    if (totalSize != totalSizeBeforeCleanUp) {
        DDLogInfo(@"Decreased disk cache size from %.3fMB to %.3fMB.", totalSizeBeforeCleanUp / (1024.0 * 1024.0), totalSize / (1024.0 * 1024.0));
    }
}

- (void)updateCacheIndexAndTouchFileForImageAtUrl:(NSURL *)url size:(NSUInteger)size
{
    NSURL *dirUrl = [self baseLocalUrlPathForUrl:url];
    CCImageDiskCacheEntry *entry = [self getCacheEntryWithDirUrlAndPlaceToTop:dirUrl];
    entry.sizeBytes = size;
    entry.lastModifiedTime = [NSDate date];

    NSError *error = nil;
    [NSFileManager.defaultManager setAttributes:@{NSFileModificationDate:entry.lastModifiedTime} ofItemAtPath:[entry.dirUrl path] error:&error];
    if (error) {
        DDLogWarn(@"Can't touch file at '%@' for image at '%@': %@", entry.dirUrl, url, error);
    }
}

@end
