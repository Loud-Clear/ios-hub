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

#import "DTTransitionHandler.h"


/**
 *  DTWorkflow is used to manage navigation between user-stories. You can put your navigation logic here and
 *  switch dynamically which story to present to user.
 *
 *  Each DTWorkflow has initialViewController method, which produces first controller from story. Caller is responsible
 *  to present it, and also responsible to dismiss the story back.
 *
 *  In other words, you can think about DTWorkflow like about this kind of puzzle in your navigation system:
 *
 *                      ;,,,,,,,,;     ;,,,,,,,,;
 *                      ;,,,,,,,,,'   ;,,,,,,,,,;
 *                      ;,,,,,,,,,'   ;,,,,,,,,,;
 *                      ;,,,,,,,,,'   :,,,,,,,,,;
 *                      ;,,,,,,,,'     ',,,,,,,,;
 *                      ;,,,,,,,;       ;,,,,,,,;
 *                      ;,,,,,..:       ;,,,,,,,;
 *                      ;,,......'     ',,,:,,,,;
 *              `';     ;.........;:`:':,'.',,,,;
 *             :;,,;  `;,...........,,,,:   ';,'
 *             ;,,,,:;:,,..............;
 *             ;,,,,,,,,...............'
 *             ;,,,,,,,,...............'
 *             ',,,,;;;,,.............,;
 *              ;,,'   ',..........;;:,,'   '::;
 *               ';     ;,.......,'   ':,'.',,,,;
 *                      ;,,,....,'     ',,,:,,,,;
 *                      ;,,,,,,,;       ;,,,,,,,;
 *                      ;,,,,,,,;       ;,,,,,,,;
 *                      ;,,,,,,,,;     ;:,,,,,,,;
 *                      ;,,,,,,,,,'   ;:,,,,,,,,;
 *                      ;,,,,,,,,,'   ;,,,,,,,,,;
 *                      ;,,,,,,,,,'   ::,,,,,,,,;
 *                      ;,,,,,,,,;     ;,,,,,,,,;
 *
 *  so each workflow has left hook (initialViewController) and caller is responsible to put it into right hole (correct presentation)
 *
 * */

@protocol DTWorkflow <NSObject>

- (UIViewController *)initialViewController;

- (void)setCompleteTarget:(id)target withAction:(SEL)action;
- (void)setFailureTarget:(id)target withAction:(SEL)action;
- (void)setBackoutTarget:(id)target withAction:(SEL)action;

- (void)completeWithLastViewController:(UIViewController *)lastController;
- (void)completeWithLastViewController:(UIViewController *)lastController context:(id)context;
- (void)failWithLastViewController:(UIViewController *)lastController error:(NSError *)error;
- (void)backoutFromInitialViewController:(UIViewController *)lastController;

@end
