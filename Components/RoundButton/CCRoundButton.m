//
// Created by Nikita Nagaynik on 29/11/2016.
// Copyright (c) 2016 Loud & Clear. All rights reserved.
//

#import "CCRoundButton.h"
#import "CCMacroses.h"

static UIControlState UIControlStateInvertHighlighted(UIControlState state)
{
    if (state == UIControlStateHighlighted) {
        return UIControlStateNormal;
    } else if (state == UIControlStateNormal) {
        return UIControlStateHighlighted;
    }
    return state;
}

@interface CCButtonStateValues<Value> : NSObject

- (void)setValue:(Value)value forState:(UIControlState)state;
- (Value)valueForState:(UIControlState)state;

- (void)setDefaultValueBlock:(Value(^)(UIControlState state))block;
@end

@implementation CCButtonStateValues {
    NSMutableDictionary *_valuesPerState;
    UIControlState _defaultState;
    id(^_defaultValueBlock)(UIControlState);
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _valuesPerState = [NSMutableDictionary new];
        _defaultState = UIControlStateNormal;
    }
    return self;
}

+ (instancetype)newWithDefaultState:(UIControlState)state
{
    CCButtonStateValues *values = [CCButtonStateValues new];
    values->_defaultState = state;
    return values;
}

- (void)setValue:(id)value forState:(UIControlState)state
{
    _valuesPerState[@(state)] = value;
}

- (id)valueForState:(UIControlState)state
{
    id value = _valuesPerState[@(state)];
    if (value) {
        return value;
    } else if (_defaultValueBlock) {
        return _defaultValueBlock(state);
    } else {
        return _valuesPerState[@(_defaultState)];
    }
}

- (void)setDefaultValueBlock:(id(^)(UIControlState state))block
{
    _defaultValueBlock = block;
}

@end

@implementation CCRoundButton {
    CCButtonStateValues<UIColor *> *_imageColors;
    CCButtonStateValues<UIColor *> *_borderColors;
    CCButtonStateValues<UIColor *> *_fillColors;

    CCButtonStateValues<UIImage *> *_leftImages;
    CCButtonStateValues<UIImage *> *_rightImages;

    CGSize _leftOffset;
    CGSize _rightOffset;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    return (id)[super buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.borderWidth = 1;
    self.backgroundColor = [UIColor clearColor];

    _imageColors = [CCButtonStateValues newWithDefaultState:UIControlStateNormal];
    _borderColors = [CCButtonStateValues newWithDefaultState:UIControlStateNormal];
    _fillColors = [CCButtonStateValues newWithDefaultState:UIControlStateNormal];

    _leftImages = [CCButtonStateValues newWithDefaultState:UIControlStateNormal];
    _rightImages = [CCButtonStateValues newWithDefaultState:UIControlStateNormal];

    @weakify(self)
    [_imageColors setDefaultValueBlock:^UIColor *(UIControlState state) {
        @strongify(self)
        return [self titleColorForState:state];
    }];
    [_borderColors setDefaultValueBlock:^UIColor *(UIControlState state) {
        @strongify(self)
        return [self titleColorForState:state];
    }];
    [_fillColors setDefaultValueBlock:^UIColor *(UIControlState state) {
        return [UIColor clearColor];
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.imageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];

    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    UIControlState state = self.state;
    if (self.inverseHighlight) {
        state = UIControlStateInvertHighlighted(state);
    }

    [self drawBackgroundForState:state];

    [self drawBorderWithState:state];

    if (!self.usesOpaqueContentWhenHighlighted && state == UIControlStateHighlighted) {
        [self renderBlock:^{
            [self drawFillWithState:state];
        }    maskingBlock:^{
            [self drawContentForState:state];
        }];
    }
    else {
        [self drawFillWithState:state];
        [self drawContentForState:state];
    }

    [self drawLeftImageForState:state];
    [self drawRightImageForState:state];
}

- (CGRect)leftImageRectForState:(UIControlState)state
{
    CGSize imageSize = [self leftImageForState:state].size;

    CGFloat leftPadding = self.bounds.size.height * 0.75f;

    return CGRectMake(leftPadding - imageSize.width*0.5f, 0.5f * (self.bounds.size.height - imageSize.height), imageSize.width, imageSize.height);
}

- (CGRect)rightImageRectForState:(UIControlState)state
{
    CGSize imageSize = [self rightImageForState:state].size;

    CGFloat rightPadding = self.bounds.size.height * 0.75f;

    return CGRectMake(self.bounds.size.width - rightPadding - imageSize.width*0.5f, 0.5f * (self.bounds.size.height - imageSize.height), imageSize.width, imageSize.height);

}

- (void)drawLeftImageForState:(UIControlState)state
{
    [self drawImage:[self leftImageForState:state]
          withColor:[self imageTintForState:state]
             inRect:[self leftImageRectForState:state]];

}

- (void)drawRightImageForState:(UIControlState)state
{
    [self drawImage:[self rightImageForState:state]
          withColor:[self imageTintForState:state]
             inRect:[self rightImageRectForState:state]];

}

- (void)drawBackgroundForState:(UIControlState)state
{
    [self drawInCurrentContext:^(CGContextRef context) {
        CGRect rect = CGRectInset(self.bounds, 1, 1);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        cornerRadius:self.bounds.size.height * 0.5f];

        CGContextAddPath(context, [path CGPath]);
        CGContextClip(context);
        [self.background drawInRect:self.bounds forState:state];
    }];
}

- (void)drawContentForState:(UIControlState)state
{
    if (self.icon) {
        [self drawImageWithState:state];
    } else {
        [self drawTextWithState:state];
    }
}

- (void)renderBlock:(void (^)())renderBlock maskingBlock:(void(^)())maskBlock
{
    UIImage *imageForMask = [self maskFromBlock:maskBlock];
    [self drawInCurrentContext:^(CGContextRef context) {
        CGImageRef mask = [self newMaskForImage:imageForMask];
        CGContextClipToMask(context, self.bounds, mask);
        renderBlock();
        CGImageRelease(mask);
    }];
}

- (BOOL)icon
{
    return [self imageForState:UIControlStateNormal] != nil;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Configuration
//-------------------------------------------------------------------------------------------

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    [_borderColors setValue:color forState:state];
}

- (void)setFillColor:(UIColor *)color forState:(UIControlState)state
{
    [_fillColors setValue:color forState:state];
}

- (void)setImageTint:(UIColor *)color forState:(UIControlState)state
{
    [_imageColors setValue:color forState:state];
}

- (UIColor *)imageTintForState:(UIControlState)state
{
    return [_imageColors valueForState:state];
}

- (UIColor *)borderColorForState:(UIControlState)state
{
    return [_borderColors valueForState:state];
}

- (UIColor *)fillColorForState:(UIControlState)state
{
    return [_fillColors valueForState:state];
}

- (void)setRightImage:(UIImage *)image forState:(UIControlState)state
{
    [_rightImages setValue:image forState:state];
}

- (UIImage *)rightImageForState:(UIControlState)state
{
    return [_rightImages valueForState:state];
}

- (void)setLeftImage:(UIImage *)image forState:(UIControlState)state
{
    [_leftImages setValue:image forState:state];
}

- (UIImage *)leftImageForState:(UIControlState)state
{
    return [_leftImages valueForState:state];
}

- (void)setRightImageOffset:(CGSize)rightOffset
{
    _rightOffset = rightOffset;
}

- (void)setLeftImageOffset:(CGSize)leftOffset
{
    _leftOffset = leftOffset;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Drawing parts
//-------------------------------------------------------------------------------------------

- (void)drawBorderWithState:(UIControlState)state
{
    [self drawInCurrentContext:^(CGContextRef context) {
        UIColor *color = [self borderColorForState:state];
        [color setStroke];
        CGFloat inset = 1 + self.borderWidth * 0.5f;
        CGRect rect = CGRectInset(self.bounds, inset, inset);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        cornerRadius:self.bounds.size.height * 0.5f];
        path.lineWidth = 1;
        [path stroke];
    }];
}

- (void)drawTextWithState:(UIControlState)state
{
    [self drawInCurrentContext:^(CGContextRef context) {

        CGRect rect = [self titleRectForContentRect:self.bounds];

        UIFont *defaultFont = self.titleLabel.font;

        NSAttributedString *attributedTitle = [self attributedTitleForState:state];
        if (attributedTitle) {
            [attributedTitle drawInRect:rect];
        } else {
            NSString *title = [self titleForState:state];
            UIColor *color = [self titleColorForState:state];

            NSDictionary *attributes = @{NSFontAttributeName: defaultFont, NSForegroundColorAttributeName: color};

            [title drawInRect:rect withAttributes:attributes];

        }
    }];
}

- (void)drawFillWithState:(UIControlState)state
{
    [self drawInCurrentContext:^(CGContextRef context) {
        UIColor *color = [self fillColorForState:state];
        [color setFill];
        CGRect rect = CGRectInset(self.bounds, 1, 1);
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:rect.size.height * 0.5f] fill];
    }];
}

- (void)drawImageWithState:(UIControlState)state
{
    [self drawImage:[self imageForState:state]
          withColor:[self imageTintForState:state]
             inRect:[self imageRectForContentRect:self.bounds]];
}

- (void)drawImage:(UIImage *)image withColor:(UIColor *)color inRect:(CGRect)rect
{
    [self drawInCurrentContext:^(CGContextRef context) {
        UIImageView *imageView = [[self class] sharedImageView];
        imageView.image = image;
        imageView.tintColor = color;
        imageView.frame = (CGRect){CGPointZero, image.size};

        CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
        [imageView.layer renderInContext:context];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private utils
//-------------------------------------------------------------------------------------------

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

//-------------------------------------------------------------------------------------------
#pragma mark - Private methods
//-------------------------------------------------------------------------------------------

- (void)drawInCurrentContext:(void(^)(CGContextRef context))block
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetBlendMode(context, kCGBlendModeNormal);

    block(context);

    CGContextRestoreGState(context);
}

- (UIImage *)maskFromBlock:(void (^)())drawBlock
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -self.bounds.size.height);

    drawBlock();

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImageView *)sharedImageView
{
    static UIImageView *imageView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    	imageView = [UIImageView new];
    });
    return imageView;
}

@end
