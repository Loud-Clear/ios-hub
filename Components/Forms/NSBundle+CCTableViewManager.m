//
//  CCTableViewManagerBundle.m
//  Pods
//
//  Created by Kel Bucey on 3/3/16.
//
//

#import "NSBundle+CCTableViewManager.h"
#import "CCTableViewManager.h"

@implementation NSBundle (CCTableViewManager)

+ (instancetype)CCTableViewManagerBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *containingBundle = [NSBundle bundleForClass:[CCTableViewManager class]];
        NSURL *bundleURL = [containingBundle URLForResource:@"CCTableViewManager" withExtension:@"bundle"];
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
    });
    
    return bundle;
}

@end
