//
//  CCHUDWindow.m
//
//  Created by Ivan on 10.12.12.
//

#import "CCHUDWindow.h"
#import "CCHUDView.h"

@implementation CCHUDWindow

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addHudView];
    }

    return self;
}

- (void)addHudView
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarSize = CGSizeMake(statusBarSize.height, statusBarSize.width);
    }

    self.hudView = [[CCHUDView alloc] initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    self.hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.hudView];
}

@end
