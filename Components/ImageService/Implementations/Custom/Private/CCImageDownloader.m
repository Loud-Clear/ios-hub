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

#import "CCImageDownloader.h"
#import "CCImageLog.h"
#import "CCDispatchQueue.h"

static NSString * const kErrorDomain = @"CCImageDownloader";

@implementation CCImageDownloader

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id) init
{
    if ((self = [super init]))
    {
        _completionQueue = [CCDispatchQueue mainQueue];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)getImageIfNeededAtUrl:(NSURL *)url withCurrentModificationDate:(NSDate *)modificationDate completion:(CCImageDownloaderBlock)completion
{
    NSParameterAssert(url);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    if (modificationDate) {
        NSString *dateString = [_dateFormatter stringFromDate:modificationDate];
        [request setValue:dateString forHTTPHeaderField:@"If-Modified-Since"];
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpUrlResponse = (id)response;
        if (![httpUrlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey:@"Internal inconsistency: response object is not of class NSHTTPURLResponse" }];
            if (completion) {
                [_completionQueue async:^{
                    completion(NO, nil, nil, error);
                }];
            }
            return;
        }

        if (error)
        {
            #if IMAGE_DBG_LOG_ENABLED
            NSString *withModificationDateText = modificationDate ? [NSString stringWithFormat:@" with modification date %@", modificationDate] : @"";
            #endif

            NSInteger statusCode = httpUrlResponse.statusCode;

            if (statusCode == 304)
            {
                CCImageDbgLog(@"%@ discovered no change in image for url \"%@\"%@.", NSStringFromClass([self class]), url, withModificationDateText);
                if (completion) {
                    [_completionQueue async:^{
                        completion(NO, nil, nil, nil);
                    }];
                }
            }
            else
            {
                CCImageDbgLog(@"%@ could NOT download image for url \"%@\"%@ because of error: %@", NSStringFromClass([self class]), url, withModificationDateText, error);
                if (completion) {
                    [_completionQueue async:^{
                        completion(NO, nil, nil, error);
                    }];
                }
            }
            return;
        }

        if (![[[self class] acceptableContentTypes] containsObject:httpUrlResponse.MIMEType]) {
            error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Unacceptable Content-Type: %@", httpUrlResponse.MIMEType] }];
            if (completion) {
                [_completionQueue async:^{
                    completion(NO, nil, nil, error);
                }];
            }
        }

        NSDate *lastModified = nil;
        NSString *lastModifiedString = httpUrlResponse.allHeaderFields[@"Last-Modified"];
        if (lastModifiedString) {
            lastModified = [[[self class] dateFormatter] dateFromString:lastModifiedString];
        }

        #if IMAGE_DBG_LOG_ENABLED
        NSString *withNewModificationDateText = lastModified ? [NSString stringWithFormat:@" with new modification date %@", lastModified] : @"";
        #endif

        CCImageDbgLog(@"%@ downloaded new image for url \"%@\"%@ of size %@kB.", NSStringFromClass([self class]), url, withNewModificationDateText, @([data length]/1024));

        if (completion) {
            [_completionQueue async:^{
                completion(YES, data, lastModified, nil);
            }];
        }
    }];

    [task resume];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

+ (NSDateFormatter *) dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName: @"GMT"];
        dateFormatter.dateFormat = @"EEE, d MMM yyyy HH:mm:ss";
    }
    return dateFormatter;
}

+ (NSSet<NSString *> *)acceptableContentTypes
{
    static NSSet<NSString *> *acceptableContentTypes = nil;
    if (!acceptableContentTypes) {
        acceptableContentTypes = [[NSSet alloc] initWithObjects:
                @"image/tiff",
                @"image/jpeg",
                @"image/gif",
                @"image/png",
                @"image/ico",
                @"image/x-icon",
                @"image/bmp",
                @"image/x-bmp",
                @"image/x-xbitmap",
                @"image/x-win-bitmap",
                        nil
        ];
    }
    return acceptableContentTypes;
}

@end
