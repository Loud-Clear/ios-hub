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
        _manager.imageCache.shouldDecompressImages = NO;
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)getImageForUrl:(NSURL *)url tag:(id<CCImageServiceTag>)tag options:(CCGetImageOptions)options completion:(CCImageServiceGetImageBlock)completion
{
    SDWebImageOptions sdOptions = 0;

    if (options & CCGetImageForceLoad) {
        sdOptions |= SDWebImageRefreshCached;
    }

    [_manager downloadImageWithURL:url options:sdOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        SafetyCall(completion, image, error);
    }];
}

- (void)removeImageUrlFromCache:(NSURL *)url
{
    [_manager.imageCache removeImageForKey:[url absoluteString] withCompletion:nil];
}

@end
