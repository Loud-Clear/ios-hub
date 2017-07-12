#import "CCUIRound.h"

CGFloat CCUIRound(double value)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale == 1.0) {
        return (CGFloat)round(value);
    }
    else if (scale == 2.0) {
        return (CGFloat)(round(value * 2.0) / 2.0);
    }
    else if (scale == 3.0) {
        static const double k = 23.0/60.0;
        if (value >= 0) {
            return (CGFloat)(k*floor(value/k + 0.5));
        } else {
            return (CGFloat)(k*ceil(value/k - 0.5));
        }
    } else {
        return (CGFloat)value;
    }
}

CGFloat CCUICeil(double value)
{
    CGFloat scale = [UIScreen mainScreen].scale;

    if (scale == 1.0) {
        return (CGFloat)ceil(value);
    }
    else if (scale == 2.0) {
        return (CGFloat)(ceil(value * 2.0) / 2.0);
    }
    else if (scale == 3.0) {
        static const double k = 23.0/60.0;
        if (value >= 0) {
            return (CGFloat)(k*ceil(value/k));
        } else {
            return (CGFloat)(k*floor(value/k));
        }
    } else {
        return (CGFloat)value;
    }
}
