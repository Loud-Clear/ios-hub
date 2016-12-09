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

#import "CCFormFilterConfirmation.h"
#import "NSError+CCTableFormManager.h"

@implementation CCFormFilterConfirmation

- (void)filterFormData:(NSMutableDictionary<NSString *, id> *)formData validationError:(NSError **)error
{
    id first = [self stringFromValue:formData[self.name]];
    id second = [self stringFromValue:formData[self.confirmationName]];
    
    if (![first isEqual:second]) {
        if (error) {
            *error = [NSError errorWithCode:0 name:self.confirmationName
                       localizedDescription:self.errorMessage];
        }
    }

    if (self.shouldDeleteConfirmationValue) {
        [formData removeObjectForKey:self.confirmationName];
    }
}

- (NSString *)stringFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return self.caseSensitive ? value : [value lowercaseString];
    } else {
        return nil;
    }
}

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)key
{
    return [self.confirmationName isEqual:key];
}

@end
