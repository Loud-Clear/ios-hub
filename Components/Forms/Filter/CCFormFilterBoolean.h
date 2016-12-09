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


@interface CCFormFilterBoolean : NSObject <CCFormFilter>

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL expectedValue;
@property (nonatomic) NSString *errorMessage;

@property (nonatomic) BOOL shouldDeleteValue;

@end
