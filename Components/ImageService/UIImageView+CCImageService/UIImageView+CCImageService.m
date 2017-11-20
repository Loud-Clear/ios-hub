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

#import <Typhoon/TyphoonComponentFactory.h>
#import <objc/runtime.h>
#import "NSObject+TyphoonDefaultFactory.h"
#import "CCImageService.h"
#import "UIImageView+CCImageService.h"
#import "CCMacroses.h"
#import "CCImageServiceIfModifiedSince.h"
#import "CCImageLog.h"
#import "CCImageServiceTag.h"


@implementation UIImageView (CCImageService)

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (CCImageViewState)cc_state
{
    return (CCImageViewState)[GetAssociatedObject(@selector(cc_state)) integerValue];
}

- (void)setCc_state:(CCImageViewState)state
{
    SetAssociatedObject(@selector(cc_state), @(state));
}

- (UIImage *)cc_notLoadedImage
{
    return GetAssociatedObject(@selector(cc_notLoadedImage));
}

- (void)setCc_notLoadedImage:(UIImage *)image
{
    SetAssociatedObject(@selector(cc_notLoadedImage), image);
}

- (UIImage *)cc_placeholderImage
{
    return GetAssociatedObject(@selector(cc_placeholderImage));
}

- (void)setCc_placeholderImage:(UIImage *)image
{
    SetAssociatedObject(@selector(cc_placeholderImage), image);
}

- (BOOL)cc_disableSetImageAnimation
{
    return (BOOL)[GetAssociatedObject(@selector(cc_disableSetImageAnimation)) boolValue];
}

- (void)setCc_disableSetImageAnimation:(BOOL)disableAnimation
{
    SetAssociatedObject(@selector(cc_disableSetImageAnimation), @(disableAnimation));
}

- (id<CCImageServiceTag>)cc_imageTag
{
    return GetAssociatedObject(@selector(cc_imageTag));
}

- (void)setCc_imageTag:(id<CCImageServiceTag>)tag
{
    SetAssociatedObject(@selector(cc_imageTag), tag);
}

- (void)cc_setImageFromURL:(NSURL *)url
{
    [self cc_setImageFromURL:url forceReload:NO completion:nil];
}

- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload
{
    [self cc_setImageFromURL:url forceReload:forceReload completion:nil];
}

- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageServiceGetImageBlock)completion
{
    id<CCImageService> imageService = [CCImageServiceIfModifiedSince newUsingTyphoon];

    [self cc_setImageFromURL:url imageService:imageService tag:nil forceReload:forceReload completion:completion];
}

- (void)cc_setImageFromURL:(NSURL *)url
              imageService:(id<CCImageService>)imageService
                       tag:(id<CCImageServiceTag>)tag
               forceReload:(BOOL)forceReload
                completion:(CCImageServiceGetImageBlock)completion
{
    NSParameterAssert(imageService);

    if (url == nil) {
        if (self.cc_notLoadedImage) {
            CCImageDbgLog(@"[%p] Image url is nil, setting notLoadedImage", self);
            self.image = self.cc_notLoadedImage;
        } else {
            CCImageDbgLog(@"[%p] Image url is nil, setting nil image", self);
            self.image = nil;
        }
        self.cc_imageUrl = nil;
        self.cc_state = CCImageViewStateNotLoaded;

        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
        SafetyCall(completion, nil, error);
        return;
    }

    if (!forceReload && [url isEqual:self.cc_imageUrl] && ![self isTagChanged:self.cc_imageTag newTag:tag]) {
        CCImageDbgLog(@"[%p] Image url is the same, doing nothing", self);
        SafetyCall(completion, self.image, nil);
        return;
    }

    CFAbsoluteTime loadStartTime = CFAbsoluteTimeGetCurrent();

    self.cc_imageUrl = url;
    self.cc_state = CCImageViewStateNotLoaded;
    if (self.cc_notLoadedImage) {
        CCImageDbgLog(@"[%p] Setting image to notLoadedImage while loading image", self);
        self.image = self.cc_notLoadedImage;
    } else {
        if (self.image != nil) {
            CCImageDbgLog(@"[%p] Setting image to nil while loading image", self);
        }
        self.image = nil;
    }

    CCGetImageOptions options = 0;
    if (forceReload) {
        options |= CCGetImageForceLoad;
    }

    self.cc_state = CCImageViewStateLoading;

    CCImageDbgLog(@"[%p] Getting image for '%@' ", self, url);

    [imageService getImageForUrl:url tag:tag options:options completion:^(UIImage *image, NSError *error)
    {
        if (self.cc_imageUrl && ![self.cc_imageUrl isEqual:url])
        {
            CCImageDbgLog(@"[%p] Image url has changed from '%@' to '%@', doing nothing", self, url, self.cc_imageUrl);

            if (!error) {
                error = [NSError errorWithDomain:CCImageServiceErrorDomain code:CCImageServiceErrorCodeImageOutdated userInfo:nil];
            }
            SafetyCall(completion, image, error);
            return;
        }

        if (!image)
        {
            CCImageDbgLog(@"[%p] Image is nil, error is '%@'", self, error);

            self.cc_state = CCImageViewStateError;
            if (self.cc_placeholderImage) {
                CCImageDbgLog(@"[%p] Setting image to placeholderImage", self);
                self.image = self.cc_placeholderImage;
            } else {
                if (self.cc_notLoadedImage) {
                    CCImageDbgLog(@"[%p] Setting image to notLoadedImage", self);
                    self.image = self.cc_notLoadedImage;
                } else {
                    CCImageDbgLog(@"[%p] Setting image to nil", self);
                    self.image = nil;
                }
            }
            SafetyCall(completion, image, error);
            return;
        }

        SafetyCallOnMain(^{
            if (CFAbsoluteTimeGetCurrent() - loadStartTime > 0.2 && !self.cc_disableSetImageAnimation)
            {
                CCImageDbgLog(@"[%p] Setting final image with transition", self);

                [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.image = image;
                    self.cc_state = CCImageViewStateLoaded;
                } completion:^(BOOL finished) {
                    SafetyCall(completion, image, error);
                }];
            }
            else {
                CCImageDbgLog(@"[%p] Setting final image without animation", self);
                self.image = image;
                self.cc_state = CCImageViewStateLoaded;
                SafetyCall(completion, image, error);
            }
        });
    }];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Deprecated methods
//-------------------------------------------------------------------------------------------

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url
{
    [self cc_setPlaceholderImage:placeholderImage andThenSetImageFromURL:url completion:nil];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion
{
    [self cc_setPlaceholderImage:placeholderImage andThenSetImageFromURL:url forceReload:NO completion:completion];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
                   forceReload:(BOOL)forceReload
                    completion:(CCImageServiceGetImageBlock)completion
{
    self.cc_placeholderImage = placeholderImage;
    [self cc_setImageFromURL:url forceReload:forceReload completion:completion];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage
        andThenSetImageFromURL:(NSURL *)url
                   forceReload:(BOOL)forceReload
              disableAnimation:(BOOL)disableAnimation
                    completion:(CCImageServiceGetImageBlock)completion;
{
    self.cc_placeholderImage = placeholderImage;
    self.cc_disableSetImageAnimation = disableAnimation;
    [self cc_setImageFromURL:url forceReload:forceReload completion:completion];
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)setCc_imageUrl:(NSURL *)url
{
    SetAssociatedObject(@selector(cc_imageUrl), url);
}

- (NSURL *)cc_imageUrl
{
    return GetAssociatedObject(@selector(cc_imageUrl));
}

- (BOOL)isTagChanged:(id<CCImageServiceTag>)oldTag newTag:(id<CCImageServiceTag>)newTag
{
    if (!oldTag && !newTag) {
        return NO;
    }
    if ((!oldTag && newTag) || (oldTag && !newTag)) {
        return YES;
    }
    return [oldTag compare:newTag] != NSOrderedSame;
}

@end
