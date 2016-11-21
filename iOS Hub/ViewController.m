//
//  ViewController.m
//  iOS Hub
//
//  Created by Aleksey Garbarev on 18/11/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import "ViewController.h"

#import "CCMacroses.h"
#import "CCObjectObserver+DatabaseAddons.h"
#import "CCObjectObserver.h"

@interface ViewController ()

@property (nonatomic, strong) NSNumber *value;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CCObjectObserver *observer = [[CCObjectObserver alloc] initWithObject:self observer:nil];
    
    [observer observeKeys:@[ @"value" ] withBlockChange:^(NSArray *keys, NSDictionary *changes) {
        NSLog(@"Keys: %@, change: %@", keys, changes);
    }];
    
    self.value = @1;
    
    SafetyCallAfter(1, ^{
        self.value = @2;
    });
    
    SafetyCallAfter(2, ^{
        self.value = @3;
    });

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
