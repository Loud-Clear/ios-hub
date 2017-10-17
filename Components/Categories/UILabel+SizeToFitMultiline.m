//
//  UILabelExtras.m
//
//  Created by Ivan Zezyulya on 22.11.11.
//

#import "UILabel+SizeToFitMultiline.h"


@implementation UILabel (Extras)

- (void)sizeToFitMultilineWithWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, 0);
    self.numberOfLines = 0;
    [self sizeToFit];
}

- (void)sizeToFitMultiline
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    self.numberOfLines = 0;
    [self sizeToFit];
}

- (void)sizeToFitWithLineCount:(NSInteger)lineCount withWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, 0);
    self.numberOfLines = lineCount;
    [self sizeToFit];
}

@end
