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

NSErrorDomain const CCImageServiceErrorDomain = @"CCImageServiceErrorDomain";

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
    [self cc_setPlaceholderImage:placeholderImage andThenSetImageFromURL:url
                     forceReload:forceReload disableAnimation:NO
                      completion:completion];
}

- (void)cc_setPlaceholderImage:(UIImage *)placeholderImage andThenSetImageFromURL:(NSURL *)url forceReload:(BOOL)forceReload disableAnimation:(BOOL)disableAnimation completion:(CCImageCompletition)completion
{
    id<CCImageService> imageService = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(CCImageService)];

    [self cc_setImageFromURL:url imageService:imageService placeholderImage:placeholderImage forceReload:forceReload
            disableAnimation:disableAnimation
                  completion:completion];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)cc_setImageFromURL:(NSURL *)url imageService:(id<CCImageService>)imageService
          placeholderImage:(UIImage *)placeholderImage forceReload:(BOOL)forceReload
          disableAnimation:(BOOL)disableAnimation completion:(CCImageCompletition)completion
{
    NSParameterAssert(imageService);

    if (url == nil) {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        self.cc_imageUrl = nil;
        
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
        CCSafeCall(completion, nil, error);
        return;
    }

    if (!forceReload && [url isEqual:self.cc_imageUrl]) {
        CCSafeCall(completion, self.image, nil);
        return;
    }

    CFAbsoluteTime loadStartTime = CFAbsoluteTimeGetCurrent();

    self.cc_imageUrl = url;
    if (placeholderImage) {
        self.image = placeholderImage;
    }

    CCGetImageOptions options = 0;
    if (forceReload) {
        options |= CCGetImageForceLoad;
    }
    
    [imageService getImageForUrl:url options:options completion:^(UIImage *image, NSError *error)
    {
        if (!image) {
            CCSafeCall(completion, image, error);
            return;
        }

        if (self.cc_imageUrl && ![self.cc_imageUrl isEqual:url]) {
            if (!error) {
                error = [NSError errorWithDomain:CCImageServiceErrorDomain code:CCImageServiceImageOutdated userInfo:nil];
            }
            CCSafeCall(completion, image, error);
            return;
        }

        SafetyCallOnMain(^{
            if (CFAbsoluteTimeGetCurrent() - loadStartTime > 0.2 && !disableAnimation)
            {
                [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.image = image;
                } completion:^(BOOL finished) {
                    CCSafeCall(completion, image, error);
                }];
            }
            else {
                self.image = image;
                CCSafeCall(completion, image, error);
            }
        });
    }];
}

static const void *kImageKey = &kImageKey;

- (void)setCc_imageUrl:(NSURL *)url
{
    SetAssociatedObject(kImageKey, url);
}

- (NSURL *)cc_imageUrl
{
    return GetAssociatedObject(kImageKey);
}

@end
