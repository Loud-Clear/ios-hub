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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface DTObjectObserver : NSObject

- (instancetype)initWithObject:(id)objectToObserve observer:(id)observer;

- (void)observeKeys:(NSArray *)keys withBlock:(void(^)())block;

/// 'changes' dictionary contains standard KVO's change dictionaries by all 'keys' (each 'change' contain NSKeyValueChangeNewKey and NSKeyValueChangeOldKey keys)
- (void)observeKeys:(NSArray *)keys withBlockChange:(void(^)(NSArray *keys, NSDictionary *changes))block;

- (void)observeKeys:(NSArray *)keys withAction:(SEL)action;

- (void)connectKey:(NSString *)srcKey to:(NSString *)dstKey on:(id)dstObject;

- (void)connectKey:(NSString *)srcKey to:(UILabel *)label;

- (void)connectKey:(NSString *)srcKey to:(NSString *)dstKey on:(id)dstObject onChanges:(NSArray *)observationKeys;

- (void)observeInvalidationWithAction:(SEL)action;

- (void)observeInvalidationWithBlock:(void(^)())block;

- (void)stopAndInvalidate;

@end
