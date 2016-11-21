////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIViewController+ССModule.h"

@implementation UIViewController (ССModule)

- (UIViewController *)asViewController
{
    return self;
}

- (UIView *)asView
{
    return self.view;
}


@end
