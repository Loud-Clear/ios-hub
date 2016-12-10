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

#import "CCTableViewCellFactory.h"
#import "CCMacroses.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTableViewCellFactory ()

@property (nonatomic, nonnull) Class cellClass;
@property (nonatomic, nullable) NSString *nibName;
@property (nonatomic) BOOL resuable;

@end

@implementation CCTableViewCellFactory

+ (instancetype)sharedPrototypeForCellClass:(Class)cellClass nibName:(NSString * __nullable)nibName reusable:(BOOL)reusable
{
    static CCTableViewCellFactory *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    	factory = [CCTableViewCellFactory new];
    });

    factory.cellClass = cellClass;
    factory.nibName = nibName;
    factory.resuable = reusable;

    return factory;
}

+ (instancetype)withCellClass:(Class)clazz reusable:(BOOL)reusable
{
    return [CCTableViewCellFactory sharedPrototypeForCellClass:clazz nibName:nil reusable:reusable];;
}

+ (instancetype)withCellClass:(Class)clazz andXib:(BOOL)useXib reusable:(BOOL)reusable
{
    return [CCTableViewCellFactory sharedPrototypeForCellClass:clazz nibName:NSStringFromClass(clazz) reusable:reusable];;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath withItem:(CCTableViewItem *)item
{
    if (self.resuable) {
        return [self cellReusableIdentifier];
    } else {
        return [NSString stringWithFormat:@"%@(%d,%d)", [self cellReusableIdentifier], (int)indexPath.section, (int)indexPath.row];
    }
}

- (NSString *)cellReusableIdentifier
{
    return self.nibName ?: NSStringFromClass(self.cellClass);
}

- (id)cellForIndexPath:(NSIndexPath *)indexPath usingTableView:(UITableView *)tableView item:(CCTableViewItem *)item
{
    NSString *identifier = [self cellIdentifierForIndexPath:indexPath withItem:item];

    if (self.cellClass && !self.nibName) {
        [tableView registerClass:self.cellClass forCellReuseIdentifier:identifier];
    }

    if (self.nibName) {
        NSCache *registeredNibs = [self nibsForTable:tableView];
        if (![[registeredNibs objectForKey:identifier] isEqualToString:self.nibName]) {
            UINib *nib = [UINib nibWithNibName:self.nibName bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            [registeredNibs setObject:self.nibName forKey:identifier];
        }
    }
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (NSCache *)nibsForTable:(UITableView *)tableView
{
    static const char *key = "regisered_xibs";
    NSCache *cache = GetAssociatedObjectFromObject(tableView, key);
    if (!cache) {
        cache = [NSCache new];
        SetAssociatedObjectToObject(tableView, key, cache);
    }
    return cache;
}

@end

NS_ASSUME_NONNULL_END
