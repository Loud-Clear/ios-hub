////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@interface CCAppVersionHUD : NSObject

+ (instancetype)sharedHUD;

/// Will add app version to left part of CCStatusBarHUD.
- (void)setup;

/// Use either NSTextAlignmentLeft or NSTextAlignmentRight.
/// Default is NSTextAlignmentLeft.
@property (nonatomic) NSTextAlignment position;

@end
