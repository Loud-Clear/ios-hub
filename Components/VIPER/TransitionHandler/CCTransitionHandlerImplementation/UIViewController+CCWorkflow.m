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

#import <objc/runtime.h>
#import "UIViewController+CCWorkflow.h"
#import "CCWorkflow.h"
#import "CCMacroses.h"

@implementation UIViewController (CCWorkflow)

static const char *kWorkflowKey;

- (void)setWorkflow:(id<CCWorkflow>)workflow
{
    SetAssociatedObject(&kWorkflowKey, workflow);
    
    for (UIViewController *child in [self childViewControllers]) {
        child.workflow = workflow;
    }
}

- (id<CCWorkflow>)workflow
{
    return GetAssociatedObject(&kWorkflowKey);
}

@end
