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
    SDWebImageDownloaderOptions sdOptions = 0;
    
    if (options & CCGetImageForceLoad) {
        sdOptions |= SDWebImageDownloaderIgnoreCachedResponse;
    }

    [_manager.imageDownloader downloadImageWithURL:url options:sdOptions progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        SafetyCall(completion, image, error);
    }];
}

- (void)removeImageUrlFromCache:(NSURL *)url
{
    [_manager.imageCache removeImageForKey:[url absoluteString] withCompletion:nil];
}

@end
