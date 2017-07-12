//
//  CCHUDView.h
//  StartFX-iOS
//
//  Created by Ivan on 09.03.13.
//
//

#import <UIKit/UIKit.h>

extern NSString *CCViewControllerNeedsStatusBarAppearanceNotification;

@interface CCHUDView : UIView

@property (nonatomic, strong) UILabel *statusLabel;

@end
