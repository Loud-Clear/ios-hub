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

@class CCTableFormManager;
@protocol CCFormRuleRegistry;

@protocol CCFormRule <NSObject>

- (void)registerTriggersWith:(id<CCFormRuleRegistry>)registry;

- (void)applyRuleOn:(CCTableFormManager *)manager;

@end


@protocol CCFormRuleRegistry <NSObject>

- (void)applyOnValueChangeForField:(NSString *)fieldName;
- (void)applyOnEndEditingForField:(NSString *)fieldName;
- (void)applyOnEditingChangedForField:(NSString *)fieldName;

@end
