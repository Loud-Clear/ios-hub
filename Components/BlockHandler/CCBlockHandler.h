////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@import Foundation;


typedef void (^CCBlockHandlerParamBlock)(id param);
typedef void (^CCBlockHandler2ParamBlock)(id param1, id param2);
typedef void (^CCBlockHandler3ParamBlock)(id param1, id param2, id param3);

/**
 * CCBlockHandler will return a block, which (when executed) will call provided selector on provided target.
 * Weakify/strongify logic is done automatically.
 */
@interface CCBlockHandler : NSObject

+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector;
+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector context:(id)context;
+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector context:(id)context1 context:(id)context2;

+ (CCBlockHandlerParamBlock)withParamWithTarget:(id)target action:(SEL)selector;
+ (CCBlockHandler2ParamBlock)with2ParamsWithTarget:(id)target action:(SEL)selector;
+ (CCBlockHandler3ParamBlock)with3ParamsWithTarget:(id)target action:(SEL)selector;

@end
