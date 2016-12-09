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

#import "CCFormFilter.h"


@interface CCFormFilterExistsValidation : NSObject <CCFormFilter>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *errorMessage;

- (instancetype)initWithKey:(NSString *)key errorMessage:(NSString *)errorMessage;

+ (instancetype)validationWithKey:(NSString *)key errorMessage:(NSString *)errorMessage;

@end
