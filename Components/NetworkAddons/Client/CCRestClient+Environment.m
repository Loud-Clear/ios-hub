//
//  CCRestClient+Environment.m
//  Fernwood
//
//  Created by Aleksey Garbarev on 25/05/2018.
//  Copyright © 2018 Loud & Clear Pty Ltd. All rights reserved.
//

#import "CCRestClient+Environment.h"
#import "CCObjectObserver.h"
#import "CCMacroses.h"

@implementation CCRestClient (Environment)

- (void)setBaseUrlFromEnvironment:(CCEnvironment *)environment keyPath:(NSString *)keyPath
{
    CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:environment observer:nil];
    
    @weakify(self)
    void(^updateBlock)() = ^{
        @strongify(self)
        NSURL *baseUrl = nil;
        id value = [environment valueForKeyPath:keyPath];
        if ([value isKindOfClass:[NSString class]]) {
            baseUrl = [NSURL URLWithString:value];
        } else if ([value isKindOfClass:[NSURL class]]) {
            baseUrl = value;
        }
        self.baseUrl = baseUrl;
    };
    
    [observer observeKeys:@[keyPath] withBlock:updateBlock];
    updateBlock();
    
    CCSetAssociatedObject("baseUrlObserver", observer);
}

@end
