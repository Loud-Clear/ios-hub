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

#import "RLMRealm+NestedTransactions.h"
#import "RLMObject.h"
#import "CCMacroses.h"

@interface RealmTransaction : NSObject <CCRealmTransaction>
@property (nonatomic, weak) RLMRealm *realm;
@end

@implementation RealmTransaction

- (void)commit
{
    [self.realm commitWriteTransaction];
}

- (void)cancel
{
    [self.realm cancelWriteTransaction];
}

@end

@implementation RLMObject (Transactions)

- (void)transactionIfNeeded:(dispatch_block_t)block
{
    if (self.realm) {
        [self.realm transactionIfNeeded:block];
    } else {
        CCSafeCall(block);
    }
}

@end


@implementation RLMRealm (NestedTransactions)

- (void)transactionIfNeeded:(dispatch_block_t)block
{
    if (self.inWriteTransaction) {
        CCSafeCall(block);
    } else {
        [self transactionWithBlock:^{
            CCSafeCall(block);
        }];
    }
}

- (id<CCRealmTransaction>)beginWriteTransactionIfNeeded
{
    RealmTransaction *transaction = [RealmTransaction new];

    if (!self.inWriteTransaction) {
        [self beginWriteTransaction];
        transaction.realm = self;
    }

    return transaction;
}


@end
