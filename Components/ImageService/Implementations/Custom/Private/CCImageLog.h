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

//#define IMAGE_DBG_LOG_ENABLED 1

#if IMAGE_DBG_LOG_ENABLED
#define CCImageDbgLog(fmt, ...) DDLogDebug(fmt, ##__VA_ARGS__)
#else
#define CCImageDbgLog(fmt, ...)
#endif
