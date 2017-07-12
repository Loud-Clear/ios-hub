#import "UILabel+Positioning.h"
#import "UIView+Positioning.h"
#import "CCUIRound.h"

@implementation UILabel (Positioning)

// See https://www.cocoanetics.com/2010/02/understanding-uifont/

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)setLowercaseCenterY:(CGFloat)y
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    self.y = y - font.ascender + font.xHeight/2 - [[self class] offsetForFont:font];
}

- (CGFloat)lowercaseCenterY
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    CGFloat result = CCUIRound(self.y + font.ascender - font.xHeight/2 + [[self class] offsetForFont:font]);
    return result;
}

- (void)setUppercaseCenterY:(CGFloat)y
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    self.y = y - font.ascender + font.capHeight/2 - [[self class] offsetForFont:font];
}

- (CGFloat)uppercaseCenterY
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    CGFloat result = CCUIRound(self.y + font.ascender - font.capHeight/2 + [[self class] offsetForFont:font]);
    return result;
}

- (void)setBaselineY:(CGFloat)y
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    self.y = y - font.ascender - [[self class] offsetForFont:font];
}

- (CGFloat)baselineY
{
    UIFont *font = [self fontFromAttributedTextOrLabel];

    CGFloat result = CCUIRound(self.y + font.ascender + [[self class] offsetForFont:font]);
    return result;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

+ (CGFloat)offsetForFont:(UIFont *)font
{
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat offset = (CCUICeil(fontHeight) - fontHeight)/2;
    return offset;
}

- (UIFont *)fontFromAttributedTextOrLabel
{
    UIFont *font = nil;

    if (self.attributedText && [self.attributedText length] != 0) {
        font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }

    if (!font) {
        font = self.font;
    }

    return font;
}

@end
