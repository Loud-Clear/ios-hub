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

#import <Foundation/Foundation.h>

extern NSString * const kCCTableFormErrorDomain;
extern NSString * const kCCErrorNameKey;

@interface NSError (CCTableFormManager)

@property (nonatomic, strong, readonly) NSString *name;

/// Use for storing multiple errors (for example returned by server).
@property (nonatomic) NSArray<NSError *> *remainingErrors;

/// Returns array consisting of self + self.remainingErrors;
- (NSArray<NSError *> *)allErrors;

/// Calls [self allErrors] and returns dictionary consisting of names and localized descriptions created from errors array.
- (NSDictionary<NSString *, NSString *> *)errorNamesAndMessages;

+ (NSDictionary<NSString *, NSString *> *)errorNamesAndMessagesFromArray:(NSArray<NSError *> *)errorsArray;

+ (instancetype)errorWithLocalizedDescription:(NSString *)localizedDescription;

/// Will create error with domain=kCCTableFormErrorDomain, provided code and userInfo consisting of name + localizedDescription.
+ (instancetype)errorWithCode:(NSInteger)code name:(NSString *)name localizedDescription:(NSString *)localizedDescription;

@end
