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

#import <UIKit/UIKit.h>


@class CCDispatchQueue;
@protocol CCImageServiceTag;

typedef void (^CCImageDiskCacheGetImageTagBlock)(id<CCImageServiceTag> tag);
typedef void (^CCImageDiskCacheGetImageBlock)(UIImage *image, NSError *error);
typedef void (^CCImageDiskCacheSaveImageBlock)(NSError *error);

@interface CCImageDiskCache : NSObject

/// Instances of tagClass should conform to CCImageServiceTag protocol.
- (instancetype)initWithTagClass:(Class<CCImageServiceTag>)tagClass;

/// Default is [CCDispatchQueue mainQueue].
@property (nonatomic) CCDispatchQueue *completionQueue;

- (void)getTagForImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageTagBlock)completion;
- (void)getImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageBlock)completion;

- (NSURL *)localUrlForRemoteUrl:(NSURL *)remoteUrl;

- (void)saveImageData:(NSData *)data forUrl:(NSURL *)url withTag:(id<CCImageServiceTag>)tag completion:(CCImageDiskCacheSaveImageBlock)completion;

/// If set, cache will try to automatically maintain its size to be no more than maxCacheSizeBytes.
/// Default value is 100MB.
@property unsigned long long maxCacheSizeBytes;
/// Clears cache completely.
- (void)clearCache;

@end
