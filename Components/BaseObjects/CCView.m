//
//  MMView.m
//  Momatu
//
//  Created by Nikita Nagaynik on 11/10/2017.
//  Copyright © 2017 LoudClear. All rights reserved.
//

#import "CCView.h"


@implementation CCView

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layout];
}

//-------------------------------------------------------------------------------------------
#pragma mark - To be Overridden Methods
//-------------------------------------------------------------------------------------------

- (void)setup
{

}

- (void)layout
{

}

@end
