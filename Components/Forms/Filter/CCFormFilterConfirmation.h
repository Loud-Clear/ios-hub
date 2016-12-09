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
#import "CCFormFilter.h"


@interface CCFormFilterConfirmation : NSObject <CCFormFilter>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *confirmationName;
@property (nonatomic) NSString *errorMessage;

@property (nonatomic) BOOL caseSensitive;

@property (nonatomic) BOOL shouldDeleteConfirmationValue;

@end
