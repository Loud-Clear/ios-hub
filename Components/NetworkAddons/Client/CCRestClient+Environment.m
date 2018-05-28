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
    CCObjectObserver *observer = [[CCObjectObserver alloc]initWithObject:environment observer:nil];
    [observer connectKey:keyPath to:@"baseUrl" on:self];
    
    CCSetAssociatedObject("baseUrlObserver", observer);
}

@end
