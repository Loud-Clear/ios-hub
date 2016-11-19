//
//  DTURLPlaceholderViewController.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "DTURLPlaceholderViewController.h"
#import "DTModuleFactoryImplementation.h"
#import "TyphoonComponentFactory.h"

@interface DTURLPlaceholderViewController ()

@end

@implementation DTURLPlaceholderViewController

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    NSURL *url = [NSURL URLWithString:self.title];
    NSAssert(url != nil, @"Url is empty. You must specify destination URL as title");

    id<DTModuleFactory> moduleFactory = [[TyphoonComponentFactory factoryForResolvingUI] componentForType:@protocol(DTModuleFactory)];
    id<DTModule> module = [moduleFactory moduleForURL:url];
    UIViewController *destination = [module asViewController];
    
    [destination view];
    
    NSAssert(destination != nil, @"Can't find controller for url=%@", url);
    
    return destination;
}

@end
