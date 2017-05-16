//
//  CCBugfenderLogger.m
//  CocoaLumberjackDemo
//
//  Created by gimix on 13/09/16.
//  Copyright © 2016 Bugfender. All rights reserved.
//

#import "CCBugfenderLogger.h"
#import <BugfenderSDK/BugfenderSDK.h>

@implementation CCBugfenderLogger

static CCBugfenderLogger *sharedInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    if (logMessage) {
        // note: some fields are ignored: tag, threadID, threadName, queueLabel
        // they can be used by the formatter to add them to the log message
        NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;

        BFLogLevel logLevel;
        switch (logMessage->_flag) {
            case DDLogFlagError     : logLevel = BFLogLevelError;     break;
            case DDLogFlagWarning   : logLevel = BFLogLevelWarning;   break;
            default                 : logLevel = BFLogLevelDefault;   break;
        }
        
        NSString* tagName = @(logMessage->_context).stringValue;
        
        [Bugfender logWithLineNumber:logMessage->_line \
                              method:logMessage->_function \
                                file:logMessage->_fileName \
                               level:logLevel \
                                 tag:tagName \
                             message:message];
    }
}

- (NSString *)loggerName {
    return @"com.bugfender.cocoalumberjack";
}

@end
