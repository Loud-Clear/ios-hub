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

#import "CCImageService.h"


@interface CCImageGetContext : NSObject

- (instancetype) initWithUrl:(NSString *)urlString;
+ (instancetype) contextWithUrl:(NSString *)urlString;

@property (nonatomic, readonly) NSString *urlString;

- (void) addCompletionBlock:(CCImageServiceGetImageBlock)completion;

// Call when some 'get image' task was started.
- (void) taskStarted;

// Call when some 'get image' task finishes.
// Number of calls to `taskStarted` and `taskFinished` should be balanced.
- (void) taskFinished;

// Will call all added completion blocks with provided parameters.
// Completion blocks will be called on main thread.
- (void) callCompletionsWithImage:(UIImage *)image error:(NSError *)error;

// When number of calls of `taskStarted` and `taskFinished` becomes equal, doneBlock will be called.
// doneBlock is called on main thread.
- (void) notifyWhenDone:(dispatch_block_t)doneBlock;


@property BOOL gotImageFromNetwork;

@end
