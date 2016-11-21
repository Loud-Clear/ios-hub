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

#import <objc/runtime.h>
#import <Typhoon/TyphoonStoryboard.h>
#import "UIViewController+URL.h"
#import "CCModuleURLParser.h"
#import "CCTransitionHandler.h"
#import "CCMacroses.h"

@interface UIStoryboard (name)

- (NSString *)dt_name;

@end

@implementation UIStoryboard (name)

+ (void)load
{
    {
        Method m1 = class_getClassMethod(self, @selector(storyboardWithName:bundle:));
        Method m2 = class_getClassMethod(self, @selector(dt_storyboardWithName:bundle:));
        method_exchangeImplementations(m1, m2);
    }
    {
        Method m1 = class_getInstanceMethod(self, @selector(instantiateViewControllerWithIdentifier:));
        Method m2 = class_getInstanceMethod(self, @selector(dt_instantiateViewControllerWithIdentifier:));
        method_exchangeImplementations(m1, m2);
    }

}


+ (UIStoryboard *)dt_storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil
{
    UIStoryboard *storyboard = [self dt_storyboardWithName:name bundle:storyboardBundleOrNil];

    SetAssociatedObjectToObject(storyboard, "name", name);

    return storyboard;
}

- (__kindof UIViewController *)dt_instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *viewController = [self dt_instantiateViewControllerWithIdentifier:identifier];
    SetAssociatedObjectToObject(viewController, "storyboardId", identifier);
    return viewController;
}

- (NSString *)dt_name
{
    return GetAssociatedObject("name");
}

@end


@implementation UIViewController (URL)




- (NSURL *)cc_url
{
    if (self.storyboard) {
        NSString *storyboardId = GetAssociatedObject("storyboardId");
        return [NSURL URLWithString:[NSString stringWithFormat:@"app:///%@/%@", self.storyboard.dt_name, storyboardId]];
    } else {
        NSString *moduleName = [CCModuleURLParser moduleNameFromViewControllerClassName:NSStringFromClass([self class])];
        if (moduleName) {
            return [NSURL URLWithString:[NSString stringWithFormat:@"app:///%@.module", moduleName]];
        } else {
            return [NSURL URLWithString:[NSString stringWithFormat:@"app:///%@.class", NSStringFromClass([self class])]];
        }
    }
}

@end
