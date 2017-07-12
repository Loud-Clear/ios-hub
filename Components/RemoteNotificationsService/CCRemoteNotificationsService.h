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
#import "CCRemoteNotificationsServiceInput.h"


@class CCRemoteNotification;
@protocol CCSingletoneStorage;

/// Notifications
extern NSString *const CCRemoteNotificationServiceNotificationDidReceiveToken;
extern NSString *const CCRemoteNotificationServiceNotificationDidReceiveNotification; // Object is CCRemoteNotification.
/// Error info
extern NSString *const CCRemoteNotificationServiceErrorDomain;
extern NSInteger const CCRemoteNotificationServiceErrorCodeDeniedInSettings;

typedef void (^CCRemoteNotificationServiceRegisterBlock)(BOOL success, NSError *error);
typedef void (^CCRemoteNotificationReceiveBlock)(__kindof CCRemoteNotification *notification);


/**
 * How to use:
 * 1. Optional - subclass CCRemoteNotificationsService.
 * 2. Make sure to set properties 'apnsTokenStorage' and 'remoteNotificationClass' on CCRemoteNotificationsService object.
 * 3. Implement notifications-related methods in your application delegate and call corresponding methods from
 *    CCRemoteNotificationsServiceInput protocol on CCRemoteNotificationsService object.
 * 4. Either subscribe to CCRemoteNotificationServiceNotificationDidReceiveToken notification, or override
 *    'handleDidRegisterWithToken:' in your subclass, and then send device token to your server.
 * 5. Call 'registerForPushNotifications:' at appropriate point in your app.
 * 6. For receiving notifications, either subscribe to CCRemoteNotificationServiceNotificationDidReceiveNotification notification,
 *    or set 'onReceiveNotification' block property, or override 'handleReceiveNotification' in your subclass.
 */
@interface CCRemoteNotificationsService : NSObject<CCRemoteNotificationsServiceInput>

@property (nonatomic) id<CCSingletoneStorage> apnsTokenStorage;
@property (nonatomic) Class remoteNotificationClass;

@property (nonatomic, readonly) NSString *token;
@property (nonatomic) NSInteger appBadgeNumber;

- (void)registerForPushNotifications:(CCRemoteNotificationServiceRegisterBlock)completion;
- (void)unregisterForPushNotifications;
- (BOOL)hasToken;

@property (nonatomic) CCRemoteNotificationReceiveBlock onReceiveNotification;
@property (nonatomic) CCRemoteNotificationReceiveBlock onWillPresentNotification;

/// For overriding in subclass:
- (UIUserNotificationType)supportedNotificationTypes;
- (void)handleReceiveNotification:(__kindof CCRemoteNotification *)notification;
- (void)handleWillPresentNotification:(__kindof CCRemoteNotification *)notification;
- (void)handleDidRegisterWithToken:(NSString *)deviceToken;

@end
