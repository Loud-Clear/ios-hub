//
//  CCFormFilterExcludeValues.h
//  DreamTeam
//
//  Created by Артем Морозенок on 6/28/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCFormFilter.h"

@interface CCFormFilterExcludeValues : NSObject <CCFormFilter>

@property (nonatomic, strong) NSArray *namesToExclude;

+ (instancetype)withArray:(NSArray *)array;

@end
