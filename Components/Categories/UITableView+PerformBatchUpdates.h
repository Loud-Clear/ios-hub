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

@import UIKit;
@import Foundation;

@interface UITableView (PerformBatchUpdates)

- (void)cc_performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates;
- (void)cc_performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(_Nullable dispatch_block_t)completion;

@end
