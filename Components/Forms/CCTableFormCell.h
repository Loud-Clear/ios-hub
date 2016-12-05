//
//  CCTableFormCell.h
//  iOS Hub
//
//  Created by Aleksey Garbarev on 01/12/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import "CCTableViewCell.h"
#import "CCActionBar.h"

@class CCTableFormItem;
@protocol CCFormOutput;

@interface CCTableFormCell: CCTableViewCell <CCActionBarDelegate>

///-----------------------------
/// @name Working With Keyboard
///-----------------------------

+ (BOOL)canFocusWithItem:(id)item;

@property (strong, readonly, nonatomic) UIResponder *responder;
@property (strong, readonly, nonatomic) NSIndexPath *indexPathForPreviousResponder;
@property (strong, readonly, nonatomic) NSIndexPath *indexPathForNextResponder;

@property (weak, readonly, nonatomic) id<CCFormOutput> output;

- (void)setupReturnKeyFor:(UITextField *)textField next:(UIReturnKeyType)next submit:(UIReturnKeyType)submit;

- (BOOL)canGoNext;

- (BOOL)canGoBack;

- (void)onNext;

- (void)onBack;

- (void)onSubmit;

///-----------------------------
/// @name Managing Cell Appearance
///-----------------------------

@property (strong, readwrite, nonatomic) CCActionBar *actionBar;

- (void)updateActionBarNavigationControl;

@end
