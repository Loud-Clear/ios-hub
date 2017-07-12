


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIApplication (TopmostViewController)

@property (strong, nonatomic, readonly) UIViewController *topmostViewController;

@end

@interface UIViewController (TopmostViewController)

@property (strong, nonatomic, readonly) UIViewController *topmostViewController;

@end