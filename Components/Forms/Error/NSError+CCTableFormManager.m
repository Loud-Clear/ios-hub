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

#import "NSError+CCTableFormManager.h"
#import <objc/runtime.h>
#import "CCMacroses.h"

NSString * const kCCTableFormErrorDomain = @"NSError+CCTableFormManager";
NSString * const kCCErrorNameKey = @"cc_name";


@implementation NSError (CCTableFormManager)

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)errorWithLocalizedDescription:(NSString *)localizedDescription
{
    if (localizedDescription == nil) {
        NSParameterAssert(localizedDescription);
        return nil;
    }

    return [self errorWithDomain:kCCTableFormErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : localizedDescription }];
}

+ (instancetype)errorWithCode:(NSInteger)code name:(NSString *)name localizedDescription:(NSString *)localizedDescription
{
    NSMutableDictionary *userInfo = [NSMutableDictionary new];

    if (name) {
        userInfo[kCCErrorNameKey] = name;
    }

    if (localizedDescription) {
        userInfo[NSLocalizedDescriptionKey] = localizedDescription;
    }

    return [self errorWithDomain:kCCTableFormErrorDomain code:code userInfo:userInfo];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (NSString *)name
{
    return self.userInfo[kCCErrorNameKey];
}

static const char kRemainingErrorsKey;

- (void)setRemainingErrors:(NSArray *)remainingErrors
{
    SetAssociatedObject(&kRemainingErrorsKey, remainingErrors);
}

- (NSArray *)remainingErrors
{
    return GetAssociatedObject(&kRemainingErrorsKey);
}

- (NSArray<NSError *> *)allErrors
{
    NSArray *remainingErrors = self.remainingErrors;

    if ([remainingErrors count] == 0) {
        return @[self];
    }

    NSMutableArray<NSError *> *allErrors = [NSMutableArray new];
    [allErrors addObject:self];
    [allErrors addObjectsFromArray:remainingErrors];

    return allErrors;
}

- (NSDictionary<NSString *, NSString *> *)errorNamesAndMessages
{
    return [NSError errorNamesAndMessagesFromArray:[self allErrors]];
}

+ (NSDictionary<NSString *, NSString *> *)errorNamesAndMessagesFromArray:(NSArray<NSError *> *)errorsArray
{
    NSMutableDictionary<NSString *, NSString *> *errorNamesAndMessages = [NSMutableDictionary new];

    for (NSError *error in errorsArray) {
        if (error.name && error.localizedDescription) {
            errorNamesAndMessages[error.name] = [error localizedDescription];
        }
    }

    return errorNamesAndMessages;
}

@end