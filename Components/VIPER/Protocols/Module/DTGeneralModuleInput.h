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

#import "DTGeneralModuleOutput.h"

@protocol DTGeneralModuleInput <NSObject>


@optional
/**
 * Called when module opened from NSURL with params (for example by clicking label link)
 * */
- (void)setInputParameters:(NSDictionary<NSString *, NSString *> *)params;

- (void)setModuleOutput:(id<DTGeneralModuleOutput>)moduleOutput;

@end
