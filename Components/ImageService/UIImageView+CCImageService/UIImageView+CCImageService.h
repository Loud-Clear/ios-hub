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
#import "CCImageService.h"


@protocol CCImageServiceTag;

typedef NS_ENUM(NSInteger, CCImageViewState)
{
    CCImageViewStateNotLoaded,
    CCImageViewStateLoading,
    CCImageViewStateError,
    CCImageViewStateLoaded
};

@interface UIImageView (CCImageService)

@property (nonatomic, readonly) NSURL *cc_imageUrl;
@property (nonatomic, readonly) CCImageViewState cc_state;
@property (nonatomic, readonly) id<CCImageServiceTag> cc_imageTag;

@property (nonatomic) UIImage *cc_notLoadedImage;
@property (nonatomic) UIImage *cc_placeholderImage;
@property (nonatomic) BOOL cc_disableSetImageAnimation;
//@property (nonatomic) UIView<CCImageViewReloadView> *cc_reloadView;

- (void)cc_setImageFromURL:(NSURL *)url;
- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload;
- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageServiceGetImageBlock)completion;

- (void)cc_setImageFromURL:(NSURL *)url
              imageService:(id<CCImageService>)imageService
                       tag:(id<CCImageServiceTag>)tag
               forceReload:(BOOL)forceReload
                completion:(CCImageServiceGetImageBlock)completion;

// Deprecated methods:
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
__deprecated_msg("use combination of other methods and 'cc_placeholderImage' property instead.");
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
                    completion:(CCImageServiceGetImageBlock)completion
__deprecated_msg("use combination of other methods and 'cc_placeholderImage' property instead.");
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
                   forceReload:(BOOL)forceReload
                    completion:(CCImageServiceGetImageBlock)completion
__deprecated_msg("use combination of other methods and 'cc_placeholderImage' property instead.");
- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
                   forceReload:(BOOL)forceReload
              disableAnimation:(BOOL)disableAnimation
                    completion:(CCImageServiceGetImageBlock)completion
__deprecated_msg("use combination of other methods and 'cc_placeholderImage'/'cc_disableSetImageAnimation' properties instead.");

@end
