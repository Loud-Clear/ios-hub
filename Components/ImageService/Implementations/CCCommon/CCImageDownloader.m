#import "CCDispatchQueue.h"////////////////////////////////////////////////////////////////////////////////
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


static NSString *const kErrorDomain = @"CCImageDownloaderIfModifiedSince";

@implementation CCImageDownloader

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)init
{
    if ((self = [super init])) {
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
        NSString *dateString = [[self dateFormatter] stringFromDate:modificationDate];
        if (dateString) {
            [request setValue:dateString forHTTPHeaderField:@"If-Modified-Since"];
        } else {
            NSAssert(NO, nil);
            DDLogError(@"Can't convert date (%@) to string", modificationDate);
        }
    }

    CCImageDbgLog(@"%@ Will download image '%@' with modificationDate '%@'", NSStringFromClass([self class]), url, modificationDate);

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpUrlResponse = (id) response;
        if (![httpUrlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Internal inconsistency: response object is not of class NSHTTPURLResponse"}];
            SafetyCallOn(_completionQueue.queue, completion, NO, nil, nil, error);
            return;
        }

        NSInteger statusCode = httpUrlResponse.statusCode;

        if (statusCode == 304) {
            CCImageDbgLog(@"%@ discovered no change in image for url \"%@\" with modification date %@.", NSStringFromClass([self class]), url, modificationDate);
            SafetyCallOn(_completionQueue.queue, completion, NO, nil, nil, nil);
            return;
        }

        if (error) {
            CCImageDbgLog(@"%@ could NOT download image for url \"%@\" because of error: %@", NSStringFromClass([self class]), url, error);
            SafetyCallOn(_completionQueue.queue, completion, NO, nil, nil, error);
            return;
        }

        NSDate *lastModified = nil;
        NSString *lastModifiedString = httpUrlResponse.allHeaderFields[@"Last-Modified"];
        if (lastModifiedString) {
            lastModified = [[self dateFormatter] dateFromString:lastModifiedString];
        }

        CCImageDbgLog(@"%@ downloaded new image for url \"%@\" with new modification date %@ of size %@kB.", NSStringFromClass([self class]), url, lastModified, @([data length] / 1024));
        SafetyCallOn(_completionQueue.queue, completion, YES, data, lastModified, nil);
    }];

    [task resume];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        dateFormatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    return dateFormatter;
}

@end
