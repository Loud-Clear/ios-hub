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

@protocol DTRealmTransaction;

@interface RLMObject (Transactions)

- (void)transactionIfNeeded:(void(^)())block;

@end

@interface RLMRealm (NestedTransactions)

- (void)transactionIfNeeded:(void(^)())block;

- (id<DTRealmTransaction>)beginWriteTransactionIfNeeded;

@end

@protocol DTRealmTransaction <NSObject>

- (void)commit;
- (void)cancel;

@end
