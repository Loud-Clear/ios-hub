//
//  CCAssemblyCollector.h
//  ShoeboxTimeline
//
//  Created by Aleksey Garbarev on 21/11/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAssemblyCollector : NSObject

+ (void)registerInitialAssemblyClass:(Class)clazz;

- (NSArray *)collectInitialAssemblyClasses;

@end

#define INITIAL_ASSEMBLY + (void)load { [CCAssemblyCollector registerInitialAssemblyClass:self]; }
