////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "RLMRealm.h"
#import "RLMObject.h"

@protocol CCRealmTransaction;

@interface RLMObject (Transactions)

- (void)transactionIfNeeded:(dispatch_block_t)block;

@end

@interface RLMRealm (NestedTransactions)

- (void)transactionIfNeeded:(dispatch_block_t)block;

- (id<CCRealmTransaction>)beginWriteTransactionIfNeeded;

@end

@protocol CCRealmTransaction <NSObject>

- (void)commit;
- (void)cancel;

@end
