////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "UITableView+PerformBatchUpdates.h"
#import "CCMacroses.h"

@implementation UITableView (PerformBatchUpdates)

- (void)cc_performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates
{
    [self cc_performBatchUpdates:updates completion:nil];
}

- (void)cc_performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(dispatch_block_t)completion
{
    if (@available(iOS 11, *)) {
        [self performBatchUpdates:updates completion:^(BOOL finished) {
            SafetyCall(completion);
        }];
    } else {
        [self beginUpdates];
        SafetyCall(updates);
        [self endUpdates];
        SafetyCall(completion);
    }
}

@end
