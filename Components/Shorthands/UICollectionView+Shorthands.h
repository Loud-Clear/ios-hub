////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 14.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

@import UIKit;


@interface UICollectionView (Shorthands)

+ (instancetype)withLayout:(UICollectionViewLayout *)layout;

- (void)registerClass:(Class)cellClass;
- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)cellClassReuseIdentifier:(Class)cellClass;

@end
