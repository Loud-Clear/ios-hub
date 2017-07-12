////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "TRCRequest.h"

extern NSString *kCCRequestRequiresSessionCustomFlagKey;
extern NSString *kCCRequestDisableLoggingCustomFlagKey;

typedef NS_ENUM(NSInteger, CCSaveMode) {
    CCSaveModeNone = 0,
    CCSaveModeInsertOrReplace = 1,
    CCSaveModeInsertOrUpdate  = 2,
};

@interface CCRequest : NSObject <TRCRequest>

// You may override these methods in your subclasses:
- (BOOL)requiresSession;
- (BOOL)disableLogging;
- (BOOL)disableCache;

- (CCSaveMode)saveMode;

@end
