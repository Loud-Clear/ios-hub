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

#import "CCImageServiceAFNetworkingImpl.h"
#import "CCLogger.h"
#import "CCMacroses.h"
#import <AFImageDownloader.h>


@implementation CCImageServiceAFNetworkingImpl {
    AFImageDownloader *_imageDownloader;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id) init
{
    if ((self = [super init]))
    {
        _imageDownloader = [AFImageDownloader new];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void) getImageForUrl:(NSURL *)url completion:(CCImageServiceGetImageBlock)completion
{
    NSParameterAssert(_imageDownloader);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [_imageDownloader downloadImageForURLRequest:request
    success:^(NSURLRequest *_, NSHTTPURLResponse *response, UIImage *image)
    {
        if (image) {
            if (response) {
                DDLogDebug(@"Loaded image for url %@ from network.", url);
            } else {
                DDLogDebug(@"Loaded image for url %@ from cache.", url);
            }
        }
        SafetyCallOnMain(completion, image, nil);
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
        DDLogWarn(@"Failed to load image for url %@: %@", url, error);
        SafetyCallOnMain(completion, nil, error);
    }];
}

@end