////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 24.10.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


extern CGFloat CCFClamp(CGFloat value, CGFloat from, CGFloat to);
extern CGFloat CCFSign(CGFloat value);
extern CGFloat CCRadiansToDegrees(CGFloat radians);
extern CGFloat CCDegreesToRadians(CGFloat degrees);

extern NSInteger CCClamp(NSInteger value, NSInteger from, NSInteger to);
extern NSInteger CCSign(NSInteger value);
extern NSInteger CCFloorTo(NSInteger x, NSInteger to);
extern NSInteger CCCeilTo(NSInteger x, NSInteger to);

extern CGPoint CCPointMultiply(CGPoint point, CGFloat multiplier);
extern CGPoint CCPointDivide(CGPoint point, CGFloat divider);
extern CGPoint CCPointAdd(CGPoint point1, CGPoint point2);
extern CGPoint CCPointSubtract(CGPoint point1, CGPoint point2);

extern CGFloat CCVectorLength(CGPoint vector);
