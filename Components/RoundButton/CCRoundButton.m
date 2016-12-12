//
// Created by Nikita Nagaynik on 29/11/2016.
// Copyright (c) 2016 Loud & Clear. All rights reserved.
//

#import "CCRoundButton.h"

@interface CCRoundButton ()

@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, strong) UIColor *borderStyleColor;
@property (nonatomic, strong) UIColor *textStyleColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIImage *icon;

@end


@implementation CCRoundButton

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setup];
    }
    return self;
}

- (instancetype)initWithIcon:(UIImage *)icon
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setTitle:@"" forState:UIControlStateNormal];
        self.icon = icon;
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
    self.icon = [self imageForState:UIControlStateNormal];
}

- (void)setup
{
    self.lastFrame = CGRectZero;
    self.titleLabel.alpha = 0;
    self.borderStyleColor = self.borderColor ? self.borderColor : [self.titleLabel textColor];
    self.textStyleColor = [self.titleLabel textColor];
    self.strokeWidth = 1;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.borderStyleColor = self.borderColor ? self.borderColor : [self.titleLabel textColor];
}

- (void)setCustomTextColor:(UIColor *)customTextColor
{
    _customTextColor = customTextColor;
    self.textStyleColor = self.customTextColor ? self.customTextColor : [self.titleLabel textColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.lastFrame, self.frame)) {
        [self draw];
        self.lastFrame = self.frame;
    }
}

- (void)draw
{
    [self setImage:[self getBackgroundForState:UIControlStateNormal]
          forState:UIControlStateNormal];
    
    [self setImage:[self getBackgroundForState:UIControlStateHighlighted]
          forState:UIControlStateHighlighted];
}

- (UIImage *)getBackgroundForState:(UIControlState)state
{
    if (self.inverseHighlight) {
        if (state == UIControlStateNormal) {
            return [self getHighlightedBackground];
        } else {
            return [self getNormalBackground];
        }
    } else {
        if (state == UIControlStateNormal) {
            return [self getNormalBackground];
        } else {
            return [self getHighlightedBackground];
        }
    }
}

- (UIImage *)getNormalBackground
{
    return self.icon ? [self getNormalBackgroundForIcon] : [self getNormalBackgroundForText];
}

- (UIImage *)getHighlightedBackground
{
    return self.icon ? [self getHighlightedBackgroundForIcon] : [self getHighlightedBackgroundForText];
}

- (UIImage *)getNormalBackgroundForText
{
    return [self drawInContext:^(CGContextRef context) {
        if (!self.hideBorder) {
            [self drawStrokeWithColor:self.borderStyleColor];
        }
        [self drawTextWithColor:self.textStyleColor];
    } opaque:NO inverse:NO];
}

- (UIImage *)getNormalBackgroundForIcon
{
    UIImage *tintedIcon = [self drawInContext:^(CGContextRef context) {
        [self drawIconWithColor:self.textStyleColor];
    } opaque:NO inverse:NO];

    return [self drawInContext:^(CGContextRef context) {
        if (!self.hideBorder) {
            [self drawStrokeWithColor:self.borderStyleColor];
        }
        [tintedIcon drawInRect:self.bounds];
    } opaque:NO inverse:NO];
}

- (UIImage *)getHighlightedBackgroundForText
{
    if (self.opaqueTitle) {
        return [self drawInContext:^(CGContextRef context) {
            [self drawRoundedRectWithColor:self.borderStyleColor];
            [self drawTextWithColor:self.textStyleColor];
        } opaque:NO inverse:NO];
    } else {
        UIImage *imageForMask = [self drawInContext:^(CGContextRef context) {
            [self drawTextWithColor:[UIColor whiteColor]];
        } opaque:NO inverse:YES];

        CGImageRef mask = [self newMaskForImage:imageForMask];

        return [self drawInContext:^(CGContextRef context) {
            CGContextClipToMask(context, self.bounds, mask);
            [self drawRoundedRectWithColor:self.borderStyleColor];
            CGImageRelease(mask);
        } opaque:NO inverse:NO];
    }
}

- (UIImage *)getHighlightedBackgroundForIcon
{
    if (self.opaqueTitle) {
        UIImage *tintedIcon = [self drawInContext:^(CGContextRef context) {
            [self drawIconWithColor:self.textStyleColor];
        } opaque:NO inverse:NO];

        return [self drawInContext:^(CGContextRef context) {
            [self drawRoundedRectWithColor:self.borderStyleColor];
            [tintedIcon drawInRect:self.bounds];
        } opaque:NO inverse:NO];
    } else {
        UIImage *imageForMask = [self drawInContext:^(CGContextRef context) {
            [self drawIconWithColor:[UIColor whiteColor]];
        } opaque:NO inverse:YES];

        CGImageRef mask = [self newMaskForImage:imageForMask];

        return [self drawInContext:^(CGContextRef context) {
            CGContextClipToMask(context, self.bounds, mask);
            [self drawRoundedRectWithColor:self.borderStyleColor];
            CGImageRelease(mask);
        } opaque:NO inverse:NO];
    }
}

- (void)drawStrokeWithColor:(UIColor *)color
{
    [color setStroke];
    CGFloat inset = 1 + self.strokeWidth * 0.5f;
    CGRect rect = CGRectInset(self.bounds, inset, inset);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    cornerRadius:self.bounds.size.height * 0.5f];
    path.lineWidth = 1;
    [path stroke];
}

- (void)drawTextWithColor:(UIColor *)color
{
    UIFont *defaultFont = self.titleLabel.font;
    UIFont *font = self.customFont ? self.customFont : defaultFont;
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color};
    
    CGSize size = [self.titleLabel.text sizeWithAttributes:attributes];
    [self.titleLabel.text drawAtPoint:[self centerPointForSize:size] withAttributes:attributes];
}

- (void)drawRoundedRectWithColor:(UIColor *)color
{
    [color setFill];
    CGRect rect = CGRectInset(self.bounds, 1, 1);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:rect.size.height * 0.5f] fill];
}

- (void)drawIconWithColor:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.icon drawAtPoint:[self centerPointForSize:self.icon.size]];

    CGContextSetBlendMode(context, kCGBlendModeSourceIn);

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, self.bounds);
}

- (CGPoint)centerPointForSize:(CGSize)size
{
    return CGPointMake(
            (self.bounds.size.width - size.width) * 0.5f,
            (self.bounds.size.height - size.height) * 0.5f
    );
}

- (CGImageRef)newMaskForImage:(UIImage *)image
{
    CGImageRef cgimage = image.CGImage;
    size_t bytesPerRow = CGImageGetBytesPerRow(cgimage);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgimage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgimage);
    size_t width = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgimage);
    CGImageRef mask = CGImageMaskCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, dataProvider, nil, NO);
    
    return mask;
}

- (UIImage *)drawInContext:(void(^)(CGContextRef context))drawBlock opaque:(BOOL)opaque inverse:(BOOL)inverse
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (inverse) {
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -self.bounds.size.height);
    }
    
    drawBlock(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
