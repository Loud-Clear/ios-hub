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

#import "CCImageGetContext.h"
#import "CCDispatchGroup.h"
#import "CCDispatchQueue.h"
#import "CCImageLog.h"


@implementation CCImageGetContext
{
    NSMutableSet<CCImageServiceGetImageBlock> *_completionBlocks;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _completionBlocks = [NSMutableSet new];

    return self;
}

- (void)dealloc
{
    CCImageDbgLog(@"for %@", _urlString);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)addCompletionBlock:(CCImageServiceGetImageBlock)completion
{
    if (!completion) {
        return;
    }

    @synchronized (_completionBlocks) {
        [_completionBlocks addObject:completion];
    }
}

- (void)callCompletionsWithImage:(UIImage *)image error:(NSError *)error
{
    @synchronized (_completionBlocks) {
        for (CCImageServiceGetImageBlock completionBlock in _completionBlocks) {
            [[CCDispatchQueue mainQueue] async:^{
                completionBlock(image, error);
            }];
        }
    }
}

@end
