//
// CCTableViewCellStyle.m
// CCTableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "CCTableViewCellStyle.h"
#import "CCTableViewManager.h"

@implementation CCTableViewCellStyle

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.backgroundImages = [[NSMutableDictionary alloc] init];
    self.selectedBackgroundImages = [[NSMutableDictionary alloc] init];
    self.cellHeight = UITableViewAutomaticDimension;
    self.defaultCellSelectionStyle = UITableViewCellSelectionStyleBlue;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CCTableViewCellStyle *style = [[self class] allocWithZone:zone];
    if (style) {
        style.backgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.backgroundImages copyWithZone:zone]];
        style.selectedBackgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.selectedBackgroundImages copyWithZone:zone]];
        style.cellHeight = self.cellHeight;
        style.defaultCellSelectionStyle = self.defaultCellSelectionStyle;
        style.backgroundImageMargin = self.backgroundImageMargin;
        style.contentViewMargin = self.contentViewMargin;
    }
    return style;
}

- (BOOL)hasCustomBackgroundImage
{
    return [self backgroundImageForCellType:CCTableViewCellTypeAny] || [self backgroundImageForCellType:CCTableViewCellTypeFirst] || [self backgroundImageForCellType:CCTableViewCellTypeMiddle] || [self backgroundImageForCellType:CCTableViewCellTypeLast] || [self backgroundImageForCellType:CCTableViewCellTypeSingle];
}

- (UIImage *)backgroundImageForCellType:(CCTableViewCellType)cellType
{
    UIImage *image = self.backgroundImages[@(cellType)];
    if (!image && cellType != CCTableViewCellTypeAny)
        image = self.backgroundImages[@(CCTableViewCellTypeAny)];
    return image;
}

- (void)setBackgroundImage:(UIImage *)image forCellType:(CCTableViewCellType)cellType
{
    if (image)
        [self.backgroundImages setObject:image forKey:@(cellType)];
}

- (BOOL)hasCustomSelectedBackgroundImage
{
    return [self selectedBackgroundImageForCellType:CCTableViewCellTypeAny] ||[self selectedBackgroundImageForCellType:CCTableViewCellTypeFirst] || [self selectedBackgroundImageForCellType:CCTableViewCellTypeMiddle] || [self selectedBackgroundImageForCellType:CCTableViewCellTypeLast] || [self selectedBackgroundImageForCellType:CCTableViewCellTypeSingle];
}

- (UIImage *)selectedBackgroundImageForCellType:(CCTableViewCellType)cellType
{
    UIImage *image = self.selectedBackgroundImages[@(cellType)];
    if (!image && cellType != CCTableViewCellTypeAny)
        image = self.selectedBackgroundImages[@(CCTableViewCellTypeAny)];
    return image;
}

- (void)setSelectedBackgroundImage:(UIImage *)image forCellType:(CCTableViewCellType)cellType
{
    if (image)
        [self.selectedBackgroundImages setObject:image forKey:@(cellType)];
}

@end
