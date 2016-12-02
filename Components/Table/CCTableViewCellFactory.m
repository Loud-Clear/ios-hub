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

@interface CCTableViewCellFactory ()

@property (nonatomic) Class cellClass;
@property (nonatomic) NSString *nibName;
@property (nonatomic) BOOL resuable;

@end

@implementation CCTableViewCellFactory

+ (instancetype)sharedPrototype
{
    static CCTableViewCellFactory *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    	factory = [CCTableViewCellFactory new];
    });

    factory.cellClass = nil;
    factory.nibName = nil;
    factory.resuable = YES;

    return factory;
}

+ (instancetype)withCellClass:(Class)clazz reusable:(BOOL)reusable
{
    CCTableViewCellFactory *factory = [CCTableViewCellFactory sharedPrototype];
    factory.cellClass = clazz;
    factory.resuable = reusable;
    return factory;
}

+ (instancetype)withXibName:(NSString *)xibName reusable:(BOOL)reusable
{
    CCTableViewCellFactory *factory = [CCTableViewCellFactory sharedPrototype];
    factory.nibName = xibName;
    factory.resuable = reusable;
    return factory;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    if (self.resuable) {
        return [self cellReusableIdentifier];
    } else {
        return [NSString stringWithFormat:@"%@(%d,%d)", [self cellReusableIdentifier], indexPath.section, indexPath.row];
    }
}

- (NSString *)cellReusableIdentifier
{
    if (self.cellClass) {
        return NSStringFromClass(self.cellClass);
    } else {
        return self.nibName;
    }
}

- (id)cellForIndexPath:(NSIndexPath *)indexPath usingTableView:(UITableView *)tableView
{
    NSString *identifier = [self cellIdentifierForIndexPath:indexPath];

    if (self.cellClass) {
        [tableView registerClass:self.cellClass forCellReuseIdentifier:identifier];
    } else if (self.nibName) {
        UINib *nib = [UINib nibWithNibName:self.nibName bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
    }

    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

@end