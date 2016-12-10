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

- (void)getImageForUrl:(NSURL *)url
               options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion
{
    SDWebImageOptions sdOptions = SDWebImageRetryFailed;
    
    if (options & CCGetImageForceLoad) {
        sdOptions |= SDWebImageRefreshCached;
    }
    [_manager downloadImageWithURL:url
                          options:sdOptions
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            SafetyCall(completion, image, error);
                        }];
}

- (void)removeImageUrlFromCache:(NSURL *)url
{
    [[SDImageCache sharedImageCache] removeImageForKey:[url absoluteString]];
}

@end
