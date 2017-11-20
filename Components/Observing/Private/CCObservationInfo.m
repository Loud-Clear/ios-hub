////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCObservationInfo.h"
#import "CCMacroses.h"

@implementation CCObservationInfo {
    BOOL _notificationScheduled;
}

- (void)notifyChangeWithTarget:(id)target key:(NSString *)key change:(NSDictionary *)change
{
    if(!self.changes) {
        self.changes = [NSMutableDictionary dictionary];
    }

    self.changes[key] = [change copy];

    if (!_notificationScheduled) {
        _notificationScheduled = YES;
        void(^notificationBlock)() = ^{
            CCSafeCall(self.block);
            CCSafeCall(self.blockChange, [self.observedKeys allObjects], self.changes);
            _notificationScheduled = NO;
            self.changes = nil;
            if (self.action) {
                SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS
                [target performSelector:self.action];
                SUPPRESS_WARNING_END
            }
        };

        if (self.batchUpdateDelay > 0) {
            SafetyCallAfter(self.batchUpdateDelay, notificationBlock);
        } else {
            CCSafeCall(notificationBlock);
        }
    }
}

@end
