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

typedef void (^CCImageDiskCacheGetImageModificationDateBlock)(NSDate *modificationDate);
typedef void (^CCImageDiskCacheGetImageBlock)(UIImage *image, NSError *error);
typedef void (^CCImageDiskCacheSaveImageBlock)(NSError *error);

@interface CCImageDiskCache : NSObject

/// Default is [CCDispatchQueue mainQueue].
@property (nonatomic) CCDispatchQueue *completionQueue;

- (void) getModificationDateForImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageModificationDateBlock)completion;
- (void) getImageAtUrl:(NSURL *)url completion:(CCImageDiskCacheGetImageBlock)completion;

- (void) saveImageData:(NSData *)data forUrl:(NSURL *)url withLastModificationDate:(NSDate *)modificationDate completion:(CCImageDiskCacheSaveImageBlock)completion;

@end
