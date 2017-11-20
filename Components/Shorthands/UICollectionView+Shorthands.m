////////////////////////////////////////////////////////////////////////////////
//
//  Momatu
//  Created by ivan at 14.11.2017.
//
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "UICollectionView+Shorthands.h"


@implementation UICollectionView (Shorthands)

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

+ (instancetype)withLayout:(UICollectionViewLayout *)layout
{
    return [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)registerClass:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:[self.class cellClassReuseIdentifier:cellClass]];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:[self.class cellClassReuseIdentifier:cellClass] forIndexPath:indexPath];
}

+ (NSString *)cellClassReuseIdentifier:(Class)cellClass
{
    return NSStringFromClass(cellClass);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

@end
