////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 9.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


@interface UIImage (CCImageGen)

+ (UIImage *)cc_roundedRectangleResizableImageWithLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)cc_roundedRectangleResizableImageWithLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;
+ (UIImage *)cc_plusImageWithSize:(CGSize)size color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
+ (UIImage *)cc_circleWithSide:(CGFloat)side lineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth;

/*!
 * @brief Makes resizable image that contains rectangle without one edge drawn.
 * @param missingEdge - 1 bit value, an edge which will not be drawn.
 */
+ (UIImage *)cc_uShapedRectangeResizableImageWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth missingEdge:(UIRectEdge)missingEdge;

@end
