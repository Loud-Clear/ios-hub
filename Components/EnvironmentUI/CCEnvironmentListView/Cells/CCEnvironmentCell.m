////////////////////////////////////////////////////////////////////////////////
//
//  LOUDCLEAR
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of LoudClear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <PureLayout/ALView+PureLayout.h>
#import "CCEnvironmentCell.h"
#import "CCEnvironmentItem.h"
#import "CCEnvironment.h"
#import "CCObjectObserver.h"
#import "CCEnvironment+PresentingName.h"

@implementation CCEnvironmentCell
{
    CCObjectObserver *_itemObserver;
    CCObjectObserver *_envObserver;
}

@synthesize item = _item;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action == @selector(duplicate:);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)cellDidLoad
{
    [super cellDidLoad];

    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];

    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)setItem:(CCEnvironmentItem *)item
{
    _item = item;

    _envObserver = [[CCObjectObserver alloc] initWithObject:item.environment observer:self];
    _itemObserver = [[CCObjectObserver alloc] initWithObject:item observer:self];

    [_envObserver observeKeys:[item.environment cc_titleNames] withAction:@selector(updateTitle)];
    [_itemObserver observeKeys:@[@"current", @"modified"] withAction:@selector(updateTitle)];
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    self.accessoryType = UITableViewCellAccessoryDetailButton;

    [self updateTitle];
}

- (void)updateTitle
{
    NSString *text = [self.item.environment cc_presentingName];
    if (self.item.modified) {
        text = [text stringByAppendingString:@" [modified]"];
    }
    self.titleLabel.text = text;
    self.titleLabel.font = self.item.current ? [UIFont boldSystemFontOfSize:15] : [UIFont systemFontOfSize:14
                                                                                                    weight:UIFontWeightThin];
}

- (void)duplicate:(id)sender
{
    [[self.item.environment class] duplicate:self.item.environment];
}


@end