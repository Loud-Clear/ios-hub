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

#import "CCFormPostProcessor.h"


@interface CCFormValidationBoolean : NSObject <CCFormPostProcessor>

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL expectedValue;
@property (nonatomic) NSString *errorMessage;

+ (instancetype)withField:(NSString *)name correctValue:(BOOL)value error:(NSString *)errorMessage;

@end
