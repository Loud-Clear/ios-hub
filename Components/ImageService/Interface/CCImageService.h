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

@protocol CCImageServiceTag;

extern NSErrorDomain const CCImageServiceErrorDomain;
extern NSInteger const CCImageServiceErrorCodeImageOutdated;

typedef void (^CCImageServiceGetImageBlock)(UIImage *image, NSError *error);
typedef void (^CCImageServiceGetImagePathBlock)(NSString *imageLocalPath, NSError *error);

typedef NS_OPTIONS(NSUInteger, CCGetImageOptions) {
    CCGetImageForceLoad = 1 << 0,
};

@protocol CCImageService <NSObject>

- (void)getImageForUrl:(NSURL *)url tag:(id<CCImageServiceTag>)tag options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion;
- (void)getImagePathForUrl:(NSURL *)remoteUrl options:(CCGetImageOptions)options completion:(CCImageServiceGetImagePathBlock)completion;

// To be deleted:
- (void)getImageForUrl:(NSURL *)url options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion;
- (void)getImageForUrl:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion;

@optional

- (void)removeImageUrlFromCache:(NSURL *)url;

@end
