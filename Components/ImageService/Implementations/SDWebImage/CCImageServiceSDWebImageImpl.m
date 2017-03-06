//
//  CCImageServiceSDWebImageImpl.m
//  DreamTeam
//
//  Created by Jay Quiambao on 6/16/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CCImageServiceSDWebImageImpl.h"
#import "SDImageCache.h"
#import "CCMacroses.h"

@implementation CCImageServiceSDWebImageImpl
{
    SDWebImageManager *_manager;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    if ((self = [super init]))
    {
        _manager = [SDWebImageManager sharedManager];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)getImageForUrl:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion
{
    [self getImageForUrl:url options:0 completion:completion];
}

- (void)getImageForUrl:(NSURL *)url
               options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion
{
    SDWebImageOptions sdOptions = 0;
    
    if (options & CCGetImageForceLoad) {
        sdOptions |= SDWebImageRefreshCached;
    }
    
    [_manager downloadImageWithURL:url options:sdOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        SafetyCall(completion, image, error);
    }];
}

- (void)getImagePathForUrl:(NSURL *)remoteUrl options:(CCGetImageOptions)options  completion:(void(^)(NSString *imageLocalPath, NSError *error))completion
{
    [self getImageForUrl:remoteUrl options:options completion:^(UIImage *image, NSError *error) {
        NSString *path = nil;
        if (image) {
            path = [_manager.imageCache defaultCachePathForKey:[remoteUrl absoluteString]];
        }
        SafetyCall(completion, path, error);
    }];
}

- (void)removeImageUrlFromCache:(NSURL *)url
{
    [_manager.imageCache removeImageForKey:[url absoluteString] withCompletion:nil];
}

@end
