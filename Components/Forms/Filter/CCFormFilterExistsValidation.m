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

#import "CCFormFilterExistsValidation.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormFilterExistsValidation

- (instancetype)initWithKey:(NSString *)key errorMessage:(NSString *)errorMessage
{
    self = [super init];
    if (self) {
        self.name = key;
        self.errorMessage = errorMessage;
    }
    return self;
}

+ (instancetype)validationWithKey:(NSString *)key errorMessage:(NSString *)errorMessage
{
    return [[self alloc] initWithKey:key errorMessage:errorMessage];
}


- (void)filterFormData:(NSMutableDictionary<NSString *, id> *)formData validationError:(NSError **)error
{
    BOOL failed = NO;
    id value = formData[self.name];

    if (!value) {
        failed = YES;
    } else if ([value isKindOfClass:[NSString class]] && [value length] == 0) {
        failed = YES;
    } else if ([value isKindOfClass:[NSNull class]]) {
        failed = YES;
    }

    if (failed && error) {
        *error = [NSError errorWithCode:0 name:self.name localizedDescription:self.errorMessage];
    }
}


@end
