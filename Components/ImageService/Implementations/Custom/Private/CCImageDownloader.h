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

#import <UIKit/UIKit.h>

@class CCDispatchQueue;


typedef void (^CCImageDownloaderBlock)(BOOL changed, NSData *imageData, NSDate *newModificationDate, NSError *error);


@interface CCImageDownloader : NSObject

/// Default is [CCDispatchQueue mainQueue].
@property (nonatomic) CCDispatchQueue *completionQueue;

- (void) getImageIfNeededAtUrl:(NSURL *)url withCurrentModificationDate:(NSDate *)modificationDate completion:(CCImageDownloaderBlock)completion;

@end
