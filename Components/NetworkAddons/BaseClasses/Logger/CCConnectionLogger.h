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

#import <Foundation/Foundation.h>
#import "TRCConnectionLogger.h"


@interface CCConnectionLogger : TRCConnectionProxy

// You can use custom logger. Default is CCConnectionLoggerCCWriter, which uses DDLogInfo macro
@property(nonatomic, strong) id<TRCConnectionLoggerWriter> writer;

@property(nonatomic) BOOL shouldLogUploadProgress;
@property(nonatomic) BOOL shouldLogDownloadProgress;

@property(nonatomic) BOOL shouldLogInputStreamContent;

@property(nonatomic) BOOL shouldLogBinaryDataAsBase64 NS_AVAILABLE(10_9, 7_0);

@property(nonatomic) BOOL shouldLogHeaders;


@end

@interface CCConnectionLoggerCCWriter : NSObject <TRCConnectionLoggerWriter>

@end
