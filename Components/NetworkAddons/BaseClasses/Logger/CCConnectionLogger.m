////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCConnectionLogger.h"
#import "CCRequest.h"
#import "CCMacroses.h"

@implementation CCConnectionLogger
{
    dispatch_queue_t _printing_queue;
}

- (instancetype)initWithConnection:(id<TRCConnection>)connection
{
    self = [super initWithConnection:connection];
    if (self) {
        [self setupLogger];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLogger];
    }
    return self;
}

- (void)setupLogger
{
    _printing_queue = dispatch_queue_create("CCLoggingConnection", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_printing_queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));

    self.shouldLogBinaryDataAsBase64 = NO;
    self.shouldLogHeaders = YES;

    self.writer = [CCConnectionLoggerCCWriter new];
}


- (id<TRCProgressHandler>)sendRequest:(NSURLRequest *)request withOptions:(id<TRCConnectionRequestSendingOptions>)options completion:(TRCConnectionCompletion)completion
{
    // Optional disable logging
    if ([options.customProperties[kCCRequestDisableLoggingCustomFlagKey] boolValue]) {
        return [self.connection sendRequest:request withOptions:options completion:completion];
    }

    [self printRequest:request];

    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();

    id <TRCProgressHandler> progressHandler = [self.connection sendRequest:request withOptions:options completion:^(id responseObject, NSError *error, id<TRCResponseInfo> responseInfo) {
        CFAbsoluteTime responseTime = CFAbsoluteTimeGetCurrent() - time;
        [self printResponseInfo:responseInfo withObject:nil error:error forRequest:request duration:responseTime];
        if (completion) {
            completion(responseObject, error, responseInfo);
        }
    }];

    if (request.HTTPBodyStream && self.shouldLogUploadProgress) {
        [self printUploadingProgress:progressHandler forRequest:request];
    }

    if (options.outputStream && self.shouldLogDownloadProgress) {
        [self printDownloadingProgress:progressHandler forRequest:request];
    }

    return progressHandler;
}


#pragma mark - Utils

- (void)printDownloadingProgress:(id <TRCProgressHandler>)progressHandler forRequest:(NSURLRequest *)request
{
    [progressHandler setDownloadProgressBlock:[self printProgressBlockForProgress:@"DOWNLOADING"
                                                                  directionMarker:@"<======================================================================================================<"
                                                                          request:request]];
}

- (TRCDownloadProgressBlock)printProgressBlockForProgress:(NSString *)progressName directionMarker:(NSString *)marker
                                                  request:(NSURLRequest *)request
{
    __block BOOL headerPrinted = NO;

    __block NSUInteger numberOfPrintedSegments = 0;

    return ^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {
        if (!headerPrinted) {
            if (totalBytesExpectedToRead > 0) {
                NSString *bytesString = [NSByteCountFormatter stringFromByteCount:totalBytesExpectedToRead
                                                                       countStyle:NSByteCountFormatterCountStyleFile];
                [self printFormat:@"%@\n", marker];
                [self printFormat:@"%@ | id: %lu | %@ | [..", progressName, (unsigned long) request, bytesString];
                headerPrinted = YES;
            }
        }
        if (headerPrinted) {
            double percent = (totalBytesRead / (double) totalBytesExpectedToRead) * 100;

            if ((int64_t) percent >= (int64_t) numberOfPrintedSegments) {
                if ((int) percent % 10 == 0) {
                    [self printFormat:@"%d%%", (int) percent];
                }
                else {
                    [self printString:@".."];
                }
                numberOfPrintedSegments += 5;
            }

            if (totalBytesRead >= totalBytesExpectedToRead) {
                [self printFormat:@"]\n%@\n", marker];
            }
        }
    };
}

- (void)printUploadingProgress:(id <TRCProgressHandler>)progressHandler forRequest:(NSURLRequest *)request
{
    [progressHandler setUploadProgressBlock:[self printProgressBlockForProgress:@"UPLOADING"
                                                                directionMarker:@">======================================================================================================>"
                                                                        request:request]];
}

- (void)printRequest:(NSURLRequest *)request
{
    NSMutableString *output = [NSMutableString new];

    NSString *bodyString = nil;
    NSData *bodyData = nil;
    if (request.HTTPBody) {
        bodyData = request.HTTPBody;
    } else if (request.HTTPBodyStream && [request.HTTPBodyStream respondsToSelector:NSSelectorFromString(@"copyWithZone:")] && self.shouldLogInputStreamContent) {
        NSInputStream *streamCopy = [request.HTTPBodyStream copy];
        [streamCopy open];
        bodyData = [[self class] dataWithContentsOfStream:streamCopy initialCapacity:NSUIntegerMax error:nil];
        [streamCopy close];
    } else if (request.HTTPBodyStream) {
        bodyString = [NSString stringWithFormat:@"[Binary Data, NSInputStream specified: %@]", request.HTTPBodyStream];
    }
    if (!bodyString) {
        bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    }

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    if (!bodyString && bodyData && self.shouldLogBinaryDataAsBase64) {
        bodyString = [NSString stringWithFormat:@">=============================binary body data=========================================================>\n%@", [bodyData base64EncodedStringWithOptions:0]];
    } else
#endif
    if (!bodyString && bodyData) {
        bodyString = [NSString stringWithFormat:@"[Binary Data, %lu bytes]", (unsigned long)[bodyData length]];
    }

    [output appendString:@">======================================================================================================>\n"];
    [output appendFormat:@"REQUEST  | id: %lu", (unsigned long) request];
    [output appendString:@"\n>------------------------------------------------------------------------------------------------------>"];
    [output appendFormat:@"\nHTTP %@ %@", request.HTTPMethod, [[request.URL absoluteString] stringByRemovingPercentEncoding]];
    if (self.shouldLogHeaders) {
        [output appendString:[self httpHeadersString:request.allHTTPHeaderFields]];
    }
    if (bodyString.length > 0) {
        [output appendString:@"\n>------------------------------------------------------------------------------------------------------>"];
        [output appendFormat:@"\n%@", bodyString];
    }
    [output appendString:@"\n>======================================================================================================>\n"];

    [self printString:output];
}

- (void)printResponseInfo:(id <TRCResponseInfo>)responseInfo withObject:(id)responseObject error:(NSError *)error
               forRequest:(NSURLRequest *)request duration:(CFAbsoluteTime)duration
{
    NSMutableString *output = [NSMutableString new];
    [output appendString:@"<======================================================================================================<\n"];
    [output appendFormat:@"RESPONSE | id: %lu | %@ | request time: %@", (unsigned long) request, [[request.URL absoluteString] stringByRemovingPercentEncoding], [self stringFromDuration:duration]];
    [output appendString:@"\n<------------------------------------------------------------------------------------------------------<"];
    
    [output appendFormat:@"\n%ld (%@)", (long) responseInfo.response.statusCode,
     [[NSHTTPURLResponse localizedStringForStatusCode:responseInfo.response.statusCode]
      capitalizedString]];
    if (self.shouldLogHeaders) {
        [output appendString:[self httpHeadersString:responseInfo.response.allHeaderFields]];
    }
    
    if ([responseInfo responseData]) {
        [output appendString:@"\n<------------------------------------------------------------------------------------------------------<"];
        NSString *description = [[NSString alloc] initWithData:[responseInfo responseData] encoding:NSUTF8StringEncoding];
        [output appendFormat:@"\n%@", description];
    }
    
    if (error && responseInfo.response.statusCode == 0) {
        [output appendString:@"\n<------------------------------------------------------------------------------------------------------<"];
        [output appendFormat:@"\nERROR: %@", error];
    }
    
    [output appendString:@"\n<======================================================================================================<\n"];

    [self printString:output];
}

- (NSString *)httpHeadersString:(NSDictionary *)headers
{
    NSMutableString *output = [NSMutableString new];
    [output appendString:@"\nHeaders:"];
    if ([headers count] == 0) {
        [output appendString:@" <none>"];
    }
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [output appendFormat:@"\n  %@: %@", key, obj];
    }];
    return output;
}

- (NSString *)stringFromDuration:(CFAbsoluteTime)duration
{
    return [NSString stringWithFormat:@"%.0fms", duration*1000];
}

- (void)printFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
{
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self printString:string];
}

- (void)printString:(NSString *)string
{
    dispatch_async(_printing_queue, ^{
        if (self.writer) {
            [self.writer writeLogString:string];
        } else {
            NSLog(@"%@", string);
        }
    });
}

+ (NSData *)dataWithContentsOfStream:(NSInputStream *)input initialCapacity:(NSUInteger)capacity error:(NSError **)error
{
    size_t bufferSize = MIN(65536U, capacity);
    uint8_t *buf = malloc(bufferSize);
    if (buf == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
        }
        return nil;
    }

    NSMutableData *result = capacity == NSUIntegerMax ? [NSMutableData data] : [NSMutableData dataWithCapacity:capacity];
    @try {
        while (true) {
            NSInteger n = [input read:buf maxLength:bufferSize];
            if (n < 0) {
                result = nil;
                if (error) {
                    *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
                }
                break;
            }
            else if (n == 0) {
                break;
            }
            else {
                [result appendBytes:buf length:n];
            }
        }
    }
    @catch (NSException *exn) {
        DDLogError(@"Caught exception writing to file: %@", exn);
        result = nil;
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EIO userInfo:nil];
        }
    }

    free(buf);
    return result;
}

@end

@implementation CCConnectionLoggerCCWriter

- (void)writeLogString:(NSString *)string
{
    DDLogInfo(@"\n%@", string);
}

@end
