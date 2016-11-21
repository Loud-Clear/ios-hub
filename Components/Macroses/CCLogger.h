//
//  CCLogger.h
//  iOS Hub
//
//  Created by Aleksey Garbarev on 19/11/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DDLogInfo

#define LOG_ASYNC_ENABLED YES

#define DDLogFlagError     (1 << 0)
#define DDLogFlagWarning   (1 << 1)
#define DDLogFlagInfo      (1 << 2)
#define DDLogFlagDebug     (1 << 3)
#define DDLogFlagVerbose   (1 << 4)

#define LOG_LEVEL_DEF DDLogFlagError // Errors only

#define LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
        [CCLogger log : isAsynchronous                                     \
                level : lvl                                                \
                 flag : flg                                                \
              context : ctx                                                \
                 file : __FILE__                                           \
             function : fnct                                               \
                 line : __LINE__                                           \
                  tag : atag                                               \
               format : (frmt), ## __VA_ARGS__]

#define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
do { if(lvl & flg) LOG_MACRO(async, lvl, flg, ctx, tag, fnct, frmt, ##__VA_ARGS__); } while(0)

#define DDLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif

@interface CCLogger : NSObject

+ (void)log:(BOOL)asynchronous
      level:(NSUInteger)level
       flag:(NSUInteger)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(9,10);

@end
