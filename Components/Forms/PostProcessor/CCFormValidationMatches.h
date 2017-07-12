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
#import "CCFormPostProcessor.h"


@interface CCFormValidationMatches : NSObject <CCFormPostProcessor>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *nameToMatch;
@property (nonatomic) NSString *errorMessage;

@property (nonatomic) BOOL caseSensitive;

+ (instancetype)withField:(NSString *)name shouldMatch:(NSString *)nameToMatch error:(NSString *)message;

+ (instancetype)withField:(NSString *)name shouldMatch:(NSString *)nameToMatch caseSensitive:(BOOL)caseSensitive error:(NSString *)message;

@end
