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

@implementation CCImageGetContext {
    NSMutableSet<CCImageServiceGetImageBlock> *_completionBlocks;
    CCDispatchGroup *_dispatchGroup;
    id selfLink;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype) init
{
    NSAssert(NO, @"Use initWith* version");
    return nil;
}

+ (instancetype)contextWithUrl:(NSString *)urlString
{
    CCImageGetContext *task = [[CCImageGetContext alloc] initWithUrl:urlString];
    return task;
}

- (id) initWithUrl:(NSString *)urlString
{
    if ((self = [super init])) {
        _urlString = urlString;
        _completionBlocks = [NSMutableSet new];
        _dispatchGroup = [CCDispatchGroup new];
    }
    return self;
}

- (void) dealloc
{
    CCImageDbgLog(@"for %@", _urlString);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void) addCompletionBlock:(CCImageServiceGetImageBlock)completion
{
    if (!completion) {
        return;
    }

    @synchronized(_completionBlocks) {
        [_completionBlocks addObject:completion];
    }
}

- (void) taskStarted
{
    if (!selfLink) {
        selfLink = self;
    }

    [_dispatchGroup enter];
}

- (void) taskFinished
{
    [_dispatchGroup leave];
}

- (void) callCompletionsWithImage:(UIImage *)image error:(NSError *)error
{
    @synchronized(_completionBlocks) {
        for (CCImageServiceGetImageBlock completionBlock in _completionBlocks) {
            [[CCDispatchQueue mainQueue] async:^{
                completionBlock(image, error);
            }];
        }
    }
}

- (void) notifyWhenDone:(dispatch_block_t)doneBlock
{
    if (!doneBlock) {
        return;
    }

    [_dispatchGroup notifyOnMainQueueWithBlock:^{
        doneBlock();
        selfLink = nil;
    }];
}

@end
