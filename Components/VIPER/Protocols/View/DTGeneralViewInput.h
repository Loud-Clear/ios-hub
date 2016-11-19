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


@protocol DTGeneralViewInput<NSObject>

- (void)setupInitialState;

- (void)showError:(NSString *)message;
- (void)showSuccess:(NSString *)message;

- (void)showLoader;
- (void)hideLoader;

@end
