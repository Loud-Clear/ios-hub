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
#import "CCImageService.h"
#import "UIImageView+CCImageService.h"
#import "CCMacroses.h"

@interface UIImageView ()
@property (nonatomic) NSURL *cc_imageUrl;
@end

@implementation UIImageView (CCImageService)

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)cc_setImageFromURL:(NSURL *)url
{
    [self cc_setPlaceholderImage:nil andThenSetImageFromURL:url];
}

- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload
{
    [self cc_setPlaceholderImage:nil andThenSetImageFromURL:url forceReload:forceReload];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url
{
    [self cc_setPlaceholderImage:placeholderImage andThenSetImageFromURL:url forceReload:NO];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload
{
    [self cc_setPlaceholderImage:placeholderImage andThenSetImageFromURL:url forceReload:forceReload completion:nil];
}

- (void)cc_setImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageCompletition)completion
{
    [self cc_setPlaceholderImage:nil andThenSetImageFromURL:url forceReload:forceReload completion:completion];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload completion:(CCImageCompletition)completion
{
    id<CCImageService> imageService = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(CCImageService)];
    
    [self cc_setImageFromURL:url imageService:imageService placeholderImage:placeholderImage forceReload:forceReload completion:completion];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)cc_setImageFromURL:(NSURL *)url imageService:(id <CCImageService>)imageService placeholderImage:(UIImage *)placeholderImage forceReload:(BOOL)forceReload completion:(CCImageCompletition)completion
{
    NSParameterAssert(imageService);

    if (url == nil) {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        self.cc_imageUrl = nil;
        return;
    }

    if (!forceReload && [url isEqual:self.cc_imageUrl]) {
        return;
    }

    CFAbsoluteTime loadStartTime = CFAbsoluteTimeGetCurrent();

    self.cc_imageUrl = url;
    if (placeholderImage) {
        self.image = placeholderImage;
    }

    [imageService getImageForUrl:url completion:^(UIImage *image, NSError *error)
    {
        if (!image) {
            SafetyCall(completion, image, error);
            return;
        }

        if (self.cc_imageUrl && ![self.cc_imageUrl isEqual:url]) {
            return;
        }

        if (CFAbsoluteTimeGetCurrent() - loadStartTime > 0.2)
        {
            [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.image = image;
            } completion:^(BOOL finished) {
                SafetyCall(completion, image, error);
            }];
        }
        else {
            self.image = image;
            SafetyCall(completion, image, error);
        }
    }];
}

static const void *kImageKey = &kImageKey;

- (void)setDt_imageUrl:(NSURL *)url
{
    SetAssociatedObject(kImageKey, url);
}

- (NSURL *)cc_imageUrl
{
    return GetAssociatedObject(kImageKey);
}

@end
