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

@property (nonatomic) NSString *urlString;

- (void)addCompletionBlock:(CCImageServiceGetImageBlock)completion;

// Will call all added completion blocks with provided parameters.
// Completion blocks will be called on main thread.
- (void)callCompletionsWithImage:(UIImage *)image error:(NSError *)error;

@end
