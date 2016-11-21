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

@interface RealmTransaction : NSObject <ССRealmTransaction>
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

- (void)transactionIfNeeded:(void(^)())block
{
    if (self.realm) {
        [self.realm transactionIfNeeded:block];
    } else {
        SafetyCall(block);
    }
}

@end


@implementation RLMRealm (NestedTransactions)

- (void)transactionIfNeeded:(void(^)())block
{
    if (self.inWriteTransaction) {
        SafetyCall(block);
    } else {
        [self transactionWithBlock:^{
            SafetyCall(block);
        }];
    }
}

- (id<ССRealmTransaction>)beginWriteTransactionIfNeeded
{
    RealmTransaction *transaction = [RealmTransaction new];

    if (!self.inWriteTransaction) {
        [self beginWriteTransaction];
        transaction.realm = self;
    }

    return transaction;
}


@end
