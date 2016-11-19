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
#import "UIViewController+DTWorkflow.h"
#import "DTWorkflow.h"
#import "DTMacroses.h"

@implementation UIViewController (DTWorkflow)

static const char *kWorkflowKey;

- (void)setWorkflow:(id<DTWorkflow>)workflow
{
    SetAssociatedObject(&kWorkflowKey, workflow);
    
    for (UIViewController *child in [self childViewControllers]) {
        child.workflow = workflow;
    }
}

- (id<DTWorkflow>)workflow
{
    return GetAssociatedObject(&kWorkflowKey);
}

@end
