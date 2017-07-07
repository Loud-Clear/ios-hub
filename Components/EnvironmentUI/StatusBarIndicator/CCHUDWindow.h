//
//  CCHUDWindow.h
//
//  Created by Ivan on 10.12.12.
//
//

#import <UIKit/UIKit.h>
#import "CCStatusBarWindow.h"

@class CCHUDView;

@interface CCHUDWindow : CCStatusBarWindow

@property (nonatomic, strong) CCHUDView *hudView;

@end
