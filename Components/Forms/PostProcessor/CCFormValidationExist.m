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

#import "CCFormValidationExist.h"
#import "NSError+CCTableFormManager.h"


@implementation CCFormValidationExist

- (instancetype)initWithName:(NSString *)name errorMessage:(NSString *)errorMessage
{
    self = [super init];
    if (self) {
        self.name = name;
        self.errorMessage = errorMessage;
    }
    return self;
}

+ (instancetype)withField:(NSString *)name error:(NSString *)errorMessage
{
    return [[self alloc] initWithName:name errorMessage:errorMessage];
}

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error
{
    BOOL failed = NO;
    id value = data[self.name];

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

    return !failed;
}


@end
