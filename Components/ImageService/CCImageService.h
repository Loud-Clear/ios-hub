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


typedef void (^CCImageServiceGetImageBlock)(UIImage *image, NSError *error);


@protocol CCImageService <NSObject>

- (void)getImageForUrl:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion;

@optional

- (void)removeImageUrlFromCache:(NSURL *)url;

@end
