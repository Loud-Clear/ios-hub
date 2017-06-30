//
//  STNotification.h
//  ShoeboxTimeline
//
//  Created by Olesya Slepchenko on 24/03/17.
//  Copyright © 2017 Loud & Clear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UNNotification;

@interface CCPushUserInfo : NSObject
@property (nonatomic) NSDictionary *aps;
@end

@interface CCRemoteNotification : NSObject

- (instancetype)initWithRemoteNotification:(NSDictionary *)userInfo;
- (instancetype)initWithUNNotification:(UNNotification *)notification;

@property (nonatomic) CCPushUserInfo *userInfo;

@end
