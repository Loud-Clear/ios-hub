//
//  UILabelExtras.h
//
//  Created by Ivan Zezyulya on 22.11.11.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UILabel (SizeToFitMultiline)

- (void)sizeToFitMultilineWithWidth:(CGFloat)width;
- (void)sizeToFitMultiline;
- (void)sizeToFitWithLineCount:(NSInteger)lineCount withWidth:(CGFloat)width;

@end
