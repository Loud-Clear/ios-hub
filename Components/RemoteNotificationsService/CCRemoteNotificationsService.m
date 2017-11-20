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

#import <UIKit/UIKit.h>
#import "CCSingletoneStorage.h"
#import "CCRemoteNotificationsService.h"
#import "CCRemoteNotification.h"
#import "CCNotificationUtils.h"
#import <UserNotifications/UserNotifications.h>
#import "CCMacroses.h"

NSString *const CCRemoteNotificationServiceNotificationDidReceiveToken = @"CCRemoteNotificationServiceNotificationDidReceiveToken";
NSString *const CCRemoteNotificationServiceNotificationDidReceiveNotification  = @"CCRemoteNotificationServiceNotificationDidReceiveNotification";

NSString *const CCRemoteNotificationServiceErrorDomain = @"CCRemoteNotificationServiceErrorDomain";
NSInteger const CCRemoteNotificationServiceErrorCodeDeniedInSettings = 123;


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface CCRemoteNotificationsService ()<UNUserNotificationCenterDelegate>
@end


@implementation CCRemoteNotificationsService
{
    NSMutableArray<CCRemoteNotificationServiceRegisterBlock> *_requestPermissionCompletions;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)init
{
    if (self = [super init]) {
        [self registerForNotification:UIApplicationDidBecomeActiveNotification
                             selector:@selector(onBecomeActiveNotification:)];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)registerForPushNotifications:(CCRemoteNotificationServiceRegisterBlock)completion
{
    [self addPermissionRequestCompletion:completion];
    [self registerToNotifications:[self supportedNotificationTypes]];
}

- (void)unregisterForPushNotifications
{
    [[self app] unregisterForRemoteNotifications];
}

- (BOOL)hasToken
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return self.token.length > 0;
#endif
}

- (NSInteger)appBadgeNumber
{
    return [self app].applicationIconBadgeNumber;
}

- (void)setAppBadgeNumber:(NSInteger)appBadgeNumber
{
    [self app].applicationIconBadgeNumber = MAX(appBadgeNumber, 0);
}

- (UIUserNotificationType)supportedNotificationTypes
{
    return UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
}

- (void)handleReceiveNotification:(__kindof CCRemoteNotification *)notification
{

}

- (void)handleWillPresentNotification:(__kindof CCRemoteNotification *)notification
{

}

- (void)handleDidRegisterWithToken:(NSString *)deviceToken
{

}

//-------------------------------------------------------------------------------------------
#pragma mark - CCRemoteNotificationServiceInput
//-------------------------------------------------------------------------------------------

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
{
    [[self app] registerForRemoteNotifications];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [[self class] tokenDataToString:deviceToken];

    DDLogInfo(@"APNS device token: %@", deviceTokenString);

    [self saveToken:deviceTokenString];
    [self completePermissionsRequestWithSuccess:YES error:nil];
    [NSNotificationCenter postNotificationToMainThread:CCRemoteNotificationServiceNotificationDidReceiveToken withObject:nil];

    [self handleDidRegisterWithToken:deviceTokenString];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self completePermissionsRequestWithSuccess:NO error:error];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    Class class = [CCRemoteNotification class];
    if (_remoteNotificationClass) {
        if ([_remoteNotificationClass isSubclassOfClass:[CCRemoteNotification class]]) {
            class = _remoteNotificationClass;
        } else {
            DDLogError(@"%@ is not subclass of %@. Instantiating notification object as %@.",
                    NSStringFromClass(_remoteNotificationClass), NSStringFromClass([CCRemoteNotification class]), NSStringFromClass([CCRemoteNotification class]));
        }
    }
    CCRemoteNotification *notification = (id)[class alloc];
    notification = [notification initWithRemoteNotification:userInfo];

    [self handleReceiveNotification:notification];

    CCSafeCall(self.onReceiveNotification, notification);

    [NSNotificationCenter postNotification:CCRemoteNotificationServiceNotificationDidReceiveNotification withObject:notification];
}

//-------------------------------------------------------------------------------------------
#pragma mark - <UNUserNotificationCenterDelegate>
//-------------------------------------------------------------------------------------------

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    CCRemoteNotification *ccnotification = [[CCRemoteNotification alloc] initWithUNNotification:notification];

    [self handleWillPresentNotification:ccnotification];

    CCSafeCall(self.onWillPresentNotification, ccnotification);

    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    CCRemoteNotification *notification = [[CCRemoteNotification alloc] initWithUNNotification:response.notification];
    CCSafeCall(self.onReceiveNotification, notification);
    CCSafeCall(completionHandler);
}

//-------------------------------------------------------------------------------------------
#pragma mark - <UIApplication> notifications
//-------------------------------------------------------------------------------------------

- (void)onBecomeActiveNotification:(NSNotification *)notification
{
    [self getAuthStatus:^(UNAuthorizationStatus status)
    {
        switch (status) {

        case UNAuthorizationStatusNotDetermined:[self refreshTokenIfNeeded];
            break;

        case UNAuthorizationStatusDenied:
            // user denied notifications
            break;

        case UNAuthorizationStatusAuthorized:
            // update token, it can be invalid
            [self refreshTokenIfNeeded];
            break;
        }
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private
//-------------------------------------------------------------------------------------------

- (UIApplication *)app
{
    return [UIApplication sharedApplication];
}

- (NSError *)deniedInSettingsError
{
    return [self deniedInSettingsErrorWithOriginalError:nil];
}

- (NSError *)deniedInSettingsErrorWithOriginalError:(NSError *)error
{
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (error) {
        userInfo[@"originalError"] = error;
    }

    return [[NSError alloc] initWithDomain:CCRemoteNotificationServiceErrorDomain
                                      code:CCRemoteNotificationServiceErrorCodeDeniedInSettings
                                  userInfo:userInfo];
}

#pragma - Token

+ (NSString *)tokenDataToString:(NSData *)tokenData
{
    const char *data = [tokenData bytes];
    NSMutableString *tokenString = [NSMutableString string];

    for (NSUInteger i = 0; i < [tokenData length]; i++) {
        [tokenString appendFormat:@"%02.2hhX", data[i]];
    }

    return [tokenString copy];
}

- (void)saveToken:(NSString *)token
{
    [self willChangeValueForKey:CCSelectorToString(token)];
    [self.apnsTokenStorage saveObject:token];
    [self didChangeValueForKey:CCSelectorToString(token)];
}

- (NSString *)token
{
    return [self.apnsTokenStorage getObject];
}

- (void)refreshTokenIfNeeded
{
    if ([self hasToken] && [_requestPermissionCompletions count] == 0) {
        [self registerForPushNotifications:nil];
    }
}

#pragma mark - Subscribers

- (void)addPermissionRequestCompletion:(CCRemoteNotificationServiceRegisterBlock)completion
{
    if (!completion) {
        return;
    }

    @synchronized (self) {
        if (!_requestPermissionCompletions) {
            _requestPermissionCompletions = [NSMutableArray new];
        }

        [_requestPermissionCompletions addObject:completion];
    }
}

#pragma mark - System authorization status for remote notitfcations

- (void)getAuthStatus:(void (^)(UNAuthorizationStatus status))completion
{
    if (SYSTEM_VERSION_LESS_THAN(@"10")) {
        if ([[self app] isRegisteredForRemoteNotifications]) {
            UIUserNotificationSettings *settings = [[self app] currentUserNotificationSettings];
            if (settings.types & UIUserNotificationTypeAlert) {
                CCSafeCall(completion, UNAuthorizationStatusAuthorized);
            } else {
                CCSafeCall(completion, UNAuthorizationStatusDenied);
            }
        } else {
            CCSafeCall(completion, UNAuthorizationStatusNotDetermined);
        }
    } else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            CCSafeCall(completion, [settings authorizationStatus]);
        }];
    }
}

- (void)registerToNotifications:(UIUserNotificationType)types
{
    //TODO: Extract system version depend code into wrapper. This logic shouldn't be here
    if (SYSTEM_VERSION_LESS_THAN(@"10"))
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        if ([[self app] isRegisteredForRemoteNotifications] && !(settings.types & UIUserNotificationTypeAlert))
        {
            [self completePermissionsRequestWithSuccess:NO error:[self deniedInSettingsError]];
        } else {
            [[self app] registerUserNotificationSettings:settings];
            [[self app] registerForRemoteNotifications];
        }
    }
    else {
        UNAuthorizationOptions options = [self unAuthorizationOptionsFromTypes:types];
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        notificationCenter.delegate = self;
        [notificationCenter requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError *error) {
                                  if (granted) {
                                      [[self app] registerForRemoteNotifications];
                                  } else {
                                      [self completePermissionsRequestWithSuccess:NO
                                                                            error:[self deniedInSettingsErrorWithOriginalError:error]];
                                  }
                              }];
    }
}

- (void)completePermissionsRequestWithSuccess:(BOOL)success
                                        error:(NSError *)error
{
    @synchronized (self) {
        for (CCRemoteNotificationServiceRegisterBlock completion in _requestPermissionCompletions) {
            CCSafeCallOnMain(completion, success, error);
        }
        _requestPermissionCompletions = nil;
    }
}

- (UNAuthorizationOptions)unAuthorizationOptionsFromTypes:(UIUserNotificationType)types
{
    UNAuthorizationOptions options = 0;
    if (types & UIUserNotificationTypeAlert) {
        options |= UNAuthorizationOptionAlert;
    }
    if (types & UIUserNotificationTypeBadge) {
        options |= UNAuthorizationOptionBadge;
    }
    if (types & UIUserNotificationTypeSound) {
        options |= UNAuthorizationOptionSound;
    }
    return options;
}


@end
