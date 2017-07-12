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
#import <PureLayout/NSLayoutConstraint+PureLayout.h>
#import "CCEnvironmentFieldTextCell.h"
#import "CCEnvironmentField.h"
#import "CCNotificationUtils.h"


@interface CCEnvironmentFieldTextCell ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation CCEnvironmentFieldTextCell
{

}

@synthesize item = _item;

- (void)cellDidLoad
{
    [super cellDidLoad];

    [self createTitleLabel];
    [self createFieldView];
}

- (void)createTitleLabel
{
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];

    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)createFieldView
{
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:self.textField];


    [self.textField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.textField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [self.textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLabel withOffset:10];

    [self.textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.textField autoSetDimension:ALDimensionHeight toSize:40];


    [self registerForNotification:UITextFieldTextDidChangeNotification selector:@selector(onTextChanged:)];



    self.textField.inputAccessoryView = self.actionBar;
    [self setupReturnKeyFor:self.textField next:UIReturnKeyNext submit:UIReturnKeyDone];

    self.fieldView = self.textField;
}

- (UIResponder *)responder
{
    return self.fieldView;
}

- (void)onTextChanged:(NSNotification *)note
{
    if (note.object == self.textField) {
        self.item.value = self.textField.text;
    }
}

- (void)setFieldValue:(id)value
{
    self.textField.text = value;
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    self.titleLabel.text = self.item.name;

    [self setFieldValue:self.item.value];

    [self updateNavigationActions];
}

+ (BOOL)canFocusWithItem:(id)item
{
    return YES;
}


@end