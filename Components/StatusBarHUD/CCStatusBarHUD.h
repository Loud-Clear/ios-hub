//
//  CCHUDView.h
//  StartFX-iOS
//
//  Created by Ivan on 09.03.13.
//
//

#import <UIKit/UIKit.h>

extern NSString *CCViewControllerNeedsStatusBarAppearanceNotification;

@interface CCStatusBarHUD : UIView

@property (nonatomic, strong) UILabel *statusLabelLeft;
@property (nonatomic, strong) UILabel *statusLabelRight;

+ (instancetype)sharedHUD;

@end
