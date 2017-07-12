//
//  STNotification.m
//  ShoeboxTimeline
//
//  Created by Olesya Slepchenko on 24/03/17.
//  Copyright © 2017 Loud & Clear. All rights reserved.
//

#import "CCRemoteNotification.h"
#import <UserNotifications/UserNotifications.h>

@implementation CCPushUserInfo

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo
{
    self = [self init];
    if (self) {
        NSDictionary *aps = userInfo[@"aps"];
        self.aps = aps;
    }
    return self;
}

@end

@interface CCRemoteNotification()
@property (nonatomic) NSDictionary *rawUserInfo;
@end

@implementation CCRemoteNotification

#pragma mark - Init

- (instancetype)initWithRemoteNotification:(NSDictionary *)userInfo
{
    self = [self init];
    if (self) {
        self.rawUserInfo = userInfo;
        self.userInfo = [[CCPushUserInfo alloc] initWithUserInfo:userInfo];
    }
    return self;
}

- (instancetype)initWithUNNotification:(UNNotification *)notification
{
    UNNotificationContent *content = notification.request.content;
    NSDictionary *userInfo = content.userInfo;
    return [self initWithRemoteNotification:userInfo];
}

#pragma mark - NSObject

- (NSString *)description
{
    return self.rawUserInfo.description;
}

@end
