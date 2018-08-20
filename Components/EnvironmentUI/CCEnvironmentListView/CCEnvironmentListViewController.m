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
#import "CCTableViewManager.h"
#import "CCEnvironment.h"
#import "CCEnvironmentListViewController.h"
#import "UIView+Positioning.h"
#import "CCTableViewItem.h"
#import "CCEnvironmentItem.h"
#import "CCEnvironmentDetailViewController.h"
#import "BaseModel.h"
#import "CCNotificationUtils.h"
#import "CCEnvironmentStorage.h"
#import "CCMacroses.h"

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

@interface CCEnvironmentListPresentationController : UIPresentationController

@property (nonatomic, strong) UIView *dimmingView;

@end


@implementation CCEnvironmentListPresentationController


- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if(self) {
        // Create the dimming view and set its initial appearance.
        self.dimmingView = [[UIView alloc] init];
        [self.dimmingView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
        [self.dimmingView setAlpha:0.0];
    }
    return self;
}

- (void)presentationTransitionWillBegin
{
    // Get critical information about the presentation.
    UIView *containerView = [self containerView];
    UIViewController *presentedViewController = [self presentedViewController];

    // Set the dimming view to the size of the container's
    // bounds, and make it transparent initially.
    [[self dimmingView] setFrame:[containerView bounds]];
    [[self dimmingView] setAlpha:0.0];

    // Insert the dimming view below everything else.
    [containerView insertSubview:[self dimmingView] atIndex:0];

    // Set up the animations for fading in the dimming view.
    if ([presentedViewController transitionCoordinator]) {
        [[presentedViewController transitionCoordinator]
                animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>
                context) {
                    // Fade in the dimming view.
                    [[self dimmingView] setAlpha:1.0];
                } completion:nil];
    } else {
        [[self dimmingView] setAlpha:1.0];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    // If the presentation was canceled, remove the dimming view.
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    // Fade the dimming view back out.
    if([[self presentedViewController] transitionCoordinator]) {
        [[[self presentedViewController] transitionCoordinator]
                animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>
                context) {
                    [[self dimmingView] setAlpha:0.0];
                } completion:nil];
    }
    else {
        [[self dimmingView] setAlpha:0.0];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    // If the dismissal was successful, remove the dimming view.
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGFloat height = self.containerView.height / 2;
    CGFloat padding = 5;

    return CGRectMake(padding, self.containerView.height - height, self.containerView.width - 2 * padding, height + 4);
}

- (BOOL)shouldPresentInFullscreen
{
    return NO;
}

@end

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

@interface CCEnvironmentListViewController ()<CCTableViewManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CCTableViewManager *tableManager;

@property (nonatomic, strong) NSDictionary<NSString *, CCEnvironment *> *originalEnvironments;

@end

@implementation CCEnvironmentListViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.transitioningDelegate = self;

    self.view.layer.cornerRadius = 4;
    self.view.layer.masksToBounds = YES;

    [self addToolbar];
    [self addTableView];

    self.tableManager = [[CCTableViewManager alloc] initWithTableView:self.tableView delegate:self];

    [self registerForNotification:CCEnvironmentStorageDidSaveNotification selector:@selector(didSaveEnvironment:)];
}

- (void)setEnvironment:(CCEnvironment *)environment
{
    _environment = environment;
    [self cacheOriginalEnvironmentsForClass:[environment class]];
    [self refreshList];
}

- (void)addToolbar
{
    self.toolbar = [UIToolbar new];
    self.toolbar.translucent = NO;
    [self.view addSubview:self.toolbar];

    [self.toolbar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.toolbar autoSetDimension:ALDimensionHeight toSize:50];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                       target:nil
                                                                       action:NULL];

    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self action:@selector(onCancel)];


    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.text = @"Select Configuration";
    [self.titleLabel sizeToFit];

    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    self.toolbar.items = @[space, title, space, cancel];
}

- (void)addTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolbar];

    UIMenuItem *testMenuItem = [[UIMenuItem alloc] initWithTitle:@"Duplicate" action:@selector(duplicate:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[testMenuItem]];
    [[UIMenuController sharedMenuController] update];
}

- (void)refreshList
{
    [self.tableManager removeAllSections];

    CCTableViewSection *section = [CCTableViewSection section];
    [section addItemsFromArray:[self itemsFromEnvironments:[[self.environment class] availableEnvironments]]];

    [self.tableManager addSection:section];
    [self refreshStatuses];
}

- (void)refreshStatuses
{
    CCTableViewSection *section = [self.tableManager.sections firstObject];
    for (CCEnvironmentItem *item in [section items]) {
        item.current = [self.environment.filename isEqualToString:item.environment.filename];
        item.modified = [self isModifiedEnvironment:item.environment];

        BOOL canDelete = !item.current && (item.modified || [item.environment canDelete]);

        item.editingStyle = canDelete ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
    }
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[CCEnvironmentListPresentationController alloc] initWithPresentedViewController:presented
                                                                   presentingViewController:presenting];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Actions
//-------------------------------------------------------------------------------------------

- (void)onSelectEnvironment:(__kindof CCEnvironment *)env
{
    [[env class] setCurrentEnvironment:env];
    [self refreshStatuses];
}

- (void)onShowEnvironment:(__kindof CCEnvironment *)env
{
    CCEnvironmentDetailViewController *viewController = [CCEnvironmentDetailViewController new];

    viewController.environment = env;

    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)onResetEnvironment:(__kindof CCEnvironment *)environment
{
    [environment reset];
}

- (void)onCancel
{
    UIViewController *presenting = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [presenting setNeedsStatusBarAppearanceUpdate];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private
//-------------------------------------------------------------------------------------------

- (void)cacheOriginalEnvironmentsForClass:(Class)clazz
{
    NSMutableDictionary *cache = [NSMutableDictionary new];
    for (NSString *filename in [(id)clazz environmentFilenames]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
        cache[filename] = [(id)clazz instanceWithContentsOfFile:path];
    }
    _originalEnvironments = cache;
}

- (BOOL)isModifiedEnvironment:(__kindof CCEnvironment *)environment
{
    __kindof CCEnvironment *original = _originalEnvironments[environment.filename];

    for (NSString *key in [[original class] allPropertyKeys]) {
        id value1 = [original valueForKey:key];
        id value2 = [environment valueForKey:key];
        if (value1 && value2 && ![value1 isEqual:value2]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)itemsFromEnvironments:(NSArray<__kindof CCEnvironment *> *)environments
{
    @weakify(self)
    NSMutableArray *result = [NSMutableArray new];
    for (__kindof CCEnvironment *environment in environments) {
        CCEnvironmentItem *item = [CCEnvironmentItem new];
        item.environment = environment;
        item.selectionStyle = UITableViewCellSelectionStyleNone;
        [item setSelectionHandler:^(CCEnvironmentItem *selected) {
            @strongify(self)
            [self onSelectEnvironment:selected.environment];
        }];
        [item setAccessoryButtonTapHandler:^(CCEnvironmentItem *selected) {
            @strongify(self)
            [self onShowEnvironment:selected.environment];
        }];
        [item setDeletionHandlerWithCompletion:^(CCEnvironmentItem *resetItem, void (^pFunction)(void)) {
            @strongify(self)

            if ([resetItem.environment canReset]) {
                [self onResetEnvironment:resetItem.environment];
                [self.tableView setEditing:NO animated:YES];
            } else {
                [resetItem.environment delete];
                pFunction();
            }

        }];
        [result addObject:item];
    }
    return result;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Events
//-------------------------------------------------------------------------------------------

- (void)didSaveEnvironment:(NSNotification *)notification
{
    CCTableViewSection *section = [self.tableManager.sections firstObject];
    if ([[section items] count] != [[[self.environment class] availableEnvironments] count]) {
        [self refreshList];
        [self.tableView reloadData];
    } else {
        [self refreshStatuses];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

- (nullable NSString *)                 tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCEnvironmentItem *item = [[self.tableManager.sections firstObject] items][(NSUInteger)indexPath.row];
    if ([item.environment canReset]) {
        return @"Reset";
    } else {
        return @"Delete";
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    BOOL result = (action == @selector(duplicate:));
    DDLogDebug(@"Can perform: %@ = %@", NSStringFromSelector(action), result?@YES:@NO);
    return result;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // required
    DDLogDebug(@"Action called %@", action);
}

@end

