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
#import "CCTableViewManager.h"

@protocol CCFormFilter;
@protocol CCFormRule;
@protocol CCTableFormManagerDelegate;

@interface CCTableFormManager : CCTableViewManager

@property (nonatomic, strong) NSArray<id<CCFormFilter>> *formFilters;
@property (nonatomic, strong) NSArray<id<CCFormRule>> *rules;

@property (nonatomic, weak) id<CCTableFormManagerDelegate> formDelegate;

@property (nonatomic) BOOL shouldUseDelegateToPresentValidationErrors;
@property (nonatomic) BOOL shouldValidateBeforeSubmit;
@property (nonatomic) BOOL shouldValidateFieldOnEndEditing;

// Data Manipulations

- (NSDictionary<NSString *, id> *)formData;

- (void)setFormData:(NSDictionary<NSString *, id> *)data;

- (void)resetForm;

// Validations

- (NSArray<NSError *> *)validationErrorsAfterFilteringData:(NSMutableDictionary<NSString *, id> *)data;

- (void)setValidationErrors:(NSDictionary<NSString *, NSString *> *)errors;


- (BOOL)isValid;

// Validates all fields value and shows errors if validation failed
// Returns YES if validated, and NO on failed validation
- (BOOL)validate;

// Fields manipulations

- (id)fieldForName:(NSString *)name;

@end

@protocol CCTableFormManagerDelegate <NSObject>

@optional
- (void)formManagerDidSubmit:(CCTableFormManager *)formManager;

- (void)formManager:(CCTableFormManager *)formManager didFailWithValidationErrors:(NSArray<NSError *> *)errors;

- (void)formManager:(CCTableFormManager *)formManager didEndEditingFieldWithName:(NSString *)fieldName;

- (void)formManager:(CCTableFormManager *)formManager didChangeEditingFieldWithName:(NSString *)fieldName;

@end