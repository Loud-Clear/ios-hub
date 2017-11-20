////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 9.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIImage+CCImageGen.h"


@implementation UIImage (CCImageGen)

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

+ (UIImage *)cc_roundedRectangleResizableImageWithLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius
{
    return [self cc_roundedRectangleResizableImageWithLineColor:lineColor fillColor:fillColor lineWidth:lineWidth cornerRadius:cornerRadius corners:UIRectCornerAllCorners];
}

+ (UIImage *)cc_roundedRectangleResizableImageWithLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners
{
    CGSize size = CGSizeMake(lineWidth + 2 * cornerRadius + 1, lineWidth + 2 * cornerRadius + 1);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth / 2, lineWidth / 2, size.width - lineWidth, size.height - lineWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    path.lineWidth = lineWidth;

    if (fillColor) {
        [fillColor setFill];
        [path fill];
    }
    if (lineColor) {
        [lineColor setStroke];
        [path stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(lineWidth + cornerRadius, lineWidth + cornerRadius, lineWidth + cornerRadius, lineWidth + cornerRadius)];

    return resizableImage;
}

+ (UIImage *)cc_uShapedRectangeResizableImageWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth missingEdge:(UIRectEdge)edge
{
    CGFloat sideLength = lineWidth * 2 + 6;
    CGSize size = CGSizeMake(sideLength, sideLength);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGRect lineRect = [self uShapedRectWithSize:size offset:lineWidth / 2 missingEdge:edge];

    [lineColor setStroke];

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;

    NSArray<NSString *> *points = [self uShapedCoordinatesInRect:lineRect missingEdge:edge];
    [path moveToPoint:CGPointFromString(points.firstObject)];
    for (int i = 1; i < points.count; ++i) {
        [path addLineToPoint:CGPointFromString(points[i])];
    }

    if (lineColor) {
        [path stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(lineWidth + 1, lineWidth + 1, lineWidth + 1, lineWidth + 1)];

    return resizableImage;
}

+ (UIImage *)cc_circleWithSide:(CGFloat)side lineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 0.0);

    UIBezierPath *path = [UIBezierPath bezierPath];

    CGPoint center = CGPointMake(side / 2, side / 2);
    CGFloat radius = side / 2 - lineWidth / 2 - 0.5f;

    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * (CGFloat) M_PI clockwise:YES];

    if (fillColor) {
        [fillColor setFill];
        [path fill];
    }
    if (lineColor) {
        [lineColor setStroke];
        [path stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (instancetype)cc_plusImageWithSize:(CGSize)size color:(UIColor *)color lineWidth:(CGFloat)lineWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    [color setStroke];

    UIBezierPath *line1Path = [UIBezierPath new];
    [line1Path moveToPoint:CGPointMake(0, size.height / 2)];
    [line1Path addLineToPoint:CGPointMake(size.width, size.height / 2)];
    line1Path.lineWidth = lineWidth;
    [line1Path stroke];

    UIBezierPath *line2Path = [UIBezierPath new];
    [line2Path moveToPoint:CGPointMake(size.width / 2, 0)];
    [line2Path addLineToPoint:CGPointMake(size.width / 2, size.height)];
    line2Path.lineWidth = lineWidth;
    [line2Path stroke];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

/*!
 * @brief Describes order and coordinates of tops in the rectangle, where one edge is missing.
 */
+ (NSArray<NSString *> *)uShapedCoordinatesInRect:(CGRect)rect missingEdge:(UIRectEdge)edge
{
    NSString *topLeft = NSStringFromCGPoint(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)));
    NSString *bottomLeft = NSStringFromCGPoint(CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)));
    NSString *bottomRight = NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
    NSString *topRight = NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)));

    switch (edge) {
    case UIRectEdgeBottom: return @[bottomLeft, topLeft, topRight, bottomRight];
    case UIRectEdgeLeft: return @[topLeft, topRight, bottomRight, bottomLeft];
    case UIRectEdgeRight: return @[topRight, topLeft, bottomLeft, bottomRight];
    default:
        return @[topLeft, bottomLeft, bottomRight, topRight];
    }
}

/*!
 * @brief Provide proper frame in which U-shaped rectangle will be rendered.
 */
+ (CGRect)uShapedRectWithSize:(CGSize)size offset:(CGFloat)offset missingEdge:(UIRectEdge)edge
{
    switch (edge) {
    case UIRectEdgeBottom: return CGRectMake(offset, offset, size.width - offset * 2, size.height - offset);
    case UIRectEdgeLeft: return CGRectMake(0, offset, size.width - offset, size.height - offset * 2);
    case UIRectEdgeRight: return CGRectMake(offset, offset, size.width - offset, size.height - offset * 2);
    default:
        return CGRectMake(offset, 0, size.width - offset * 2, size.height - offset);
    }
}

@end
