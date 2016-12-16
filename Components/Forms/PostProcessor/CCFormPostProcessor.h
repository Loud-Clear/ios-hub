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

@protocol CCFormPostProcessor <NSObject>

@optional

- (BOOL)validateData:(NSDictionary<NSString *, id> *)data error:(NSError **)error;

- (void)postProcessData:(NSMutableDictionary<NSString *, id> *)mutableData;

- (BOOL)shouldValidateAfterEndEditingName:(NSString *)name;

@end
