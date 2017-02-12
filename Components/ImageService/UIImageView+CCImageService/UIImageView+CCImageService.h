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

@protocol CCImageService;

typedef void(^CCImageCompletition)(UIImage *image, NSError *error);

@interface UIImageView (CCImageService)

@property (nonatomic, readonly) NSURL *cc_imageUrl;

- (void)cc_setImageFromURL:(NSURL *)url;
- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload;

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url;
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload;

- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageCompletition)completion;
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageCompletition)completion;

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url
                   forceReload:(BOOL)forceReload disableAnimation:(BOOL)disableAnimation
                    completion:(CCImageCompletition)completion;
@end
