//
//  CCURLPlaceholderViewController.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCURLPlaceholderViewController.h"
#import "CCModuleFactoryImplementation.h"
#import "TyphoonComponentFactory.h"

@interface CCURLPlaceholderViewController ()

@end

@implementation CCURLPlaceholderViewController

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    NSURL *url = [NSURL URLWithString:self.title];
    NSAssert(url != nil, @"Url is empty. You must specify destination URL as title");

    id<CCModuleFactory> moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(CCModuleFactory)];
    id<CCModule> module = [moduleFactory moduleForURL:url];
    UIViewController *destination = [module asViewController];
    
    [destination view];
    
    NSAssert(destination != nil, @"Can't find controller for url=%@", url);
    
    return destination;
}

@end
