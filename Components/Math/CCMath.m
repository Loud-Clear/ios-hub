////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 24.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCMath.h"


CGFloat CCFClamp(CGFloat value, CGFloat from, CGFloat to)
{
    return fmax(from, fmin(value, to));
}

NSInteger CCClamp(NSInteger value, NSInteger from, NSInteger to)
{
    return MAX(from, MIN(value, to));
}

CGFloat CCFSign(CGFloat value)
{
    return value < 0 ? -1.0 : 1.0;
}

NSInteger CCSign(NSInteger value)
{
    return value < 0 ? -1 : 1;
}

CGFloat CCRadiansToDegrees(CGFloat radians)
{
    return radians * (180.0 / M_PI);
}

CGFloat CCDegreesToRadians(CGFloat degrees)
{
    return (degrees / 180.0) * M_PI;
}

CGPoint CCPointMultiply(CGPoint point, CGFloat multiplier)
{
    return CGPointMake(point.x * multiplier, point.y * multiplier);
}

CGPoint CCPointDivide(CGPoint point, CGFloat divider)
{
    return CGPointMake(point.x / divider, point.y / divider);
}

CGPoint CCPointAdd(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint CCPointSubtract(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

CGFloat CCVectorLength(CGPoint vector)
{
    return sqrt(vector.x * vector.x + vector.y * vector.y);
}

NSInteger CCFloorIntTo(NSInteger x, NSInteger to)
{
    return to * ((x + to - 1) / to);
}

NSInteger CCCeilIntTo(NSInteger x, NSInteger to)
{
    return x - x%to;
}
