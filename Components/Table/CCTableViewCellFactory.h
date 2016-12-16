////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCTableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCTableViewCellFactory : NSObject

+ (instancetype)withCellClass:(Class)clazz reusable:(BOOL)reusable;
+ (instancetype)withCellClass:(Class)clazz andXib:(BOOL)useXib reusable:(BOOL)reusable;

- (id)cellForIndexPath:(NSIndexPath *)indexPath usingTableView:(UITableView *)tableView item:(CCTableViewItem *)item;

- (Class)cellClass;

@end

NS_ASSUME_NONNULL_END
