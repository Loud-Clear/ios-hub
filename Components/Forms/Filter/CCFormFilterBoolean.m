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

#import "CCFormFilterBoolean.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormFilterBoolean

- (void)filterFormData:(NSMutableDictionary<NSString *, id> *)formData validationError:(NSError **)error
{
    NSNumber *value = formData[self.name];
    if ([value boolValue] != self.expectedValue) {
        if (error) {
            *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.errorMessage];
        }
    }

    if (self.shouldDeleteValue) {
        [formData removeObjectForKey:self.name];
    }
}

@end
