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
@class PINMemoryCache;
@protocol CCImageServiceTag;


typedef void (^ImageMemoryCacheGetImageBlock)(UIImage *image, id<CCImageServiceTag> tag);
typedef void (^ImageMemoryCacheSaveImageBlock)(BOOL saved);

@interface CCImageMemoryCache : NSObject

@property (nonatomic, readonly) PINMemoryCache *memoryCache;

/// Default is [CCDispatchQueue mainQueue].
@property (nonatomic) CCDispatchQueue *completionQueue;

// NOTE: all completion blocks are called on 'completionQueue'.

/// If 'image' is non-nil, image is not in cache.
- (void)getImageAtUrl:(NSURL *)url completion:(ImageMemoryCacheGetImageBlock)completion;
- (void)saveImage:(UIImage *)image forUrl:(NSURL *)url withTag:(id<CCImageServiceTag>)tag completion:(ImageMemoryCacheSaveImageBlock)completion;

@end
