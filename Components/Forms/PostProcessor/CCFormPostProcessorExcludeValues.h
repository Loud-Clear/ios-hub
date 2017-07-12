//
//  CCFormPostProcessorExcludeValues.h
//  DreamTeam
//
//  Created by Артем Морозенок on 6/28/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCFormPostProcessor.h"

@interface CCFormPostProcessorExcludeValues : NSObject <CCFormPostProcessor>

@property (nonatomic, strong) NSArray *namesToExclude;

+ (instancetype)withFieldsArray:(NSArray *)array;

@end
