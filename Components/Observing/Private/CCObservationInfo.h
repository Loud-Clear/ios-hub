////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CCObservationInfo : NSObject

@property (nonatomic, copy) void(^block)();
@property (nonatomic, copy) void(^blockChange)(NSArray* keys, NSDictionary *change);
@property (nonatomic) SEL action;
@property (nonatomic) NSSet *observedKeys;
@property (nonatomic) CGFloat batchUpdateDelay;

@property (nonatomic, strong) NSMutableDictionary *changes;

- (void)notifyChangeWithTarget:(id)target key:(NSString *)key change:(NSDictionary *)change;

@end
