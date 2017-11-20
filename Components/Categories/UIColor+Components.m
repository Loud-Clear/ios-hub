#import "UIColor+Components.h"

@implementation UIColor (Components)

- (CGColorSpaceModel) colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (CGFloat) red
{
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) {
        const CGFloat *c = CGColorGetComponents(self.CGColor);
        return c[0];
    }

    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat) green
{
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) {
        const CGFloat *c = CGColorGetComponents(self.CGColor);
        return c[0];
    }

    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[1];
}

- (CGFloat) blue
{
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) {
        const CGFloat *c = CGColorGetComponents(self.CGColor);
        return c[0];
    }

    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[2];
}

- (CGFloat) alpha
{
    return CGColorGetAlpha(self.CGColor);
}

@end
