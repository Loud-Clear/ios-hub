#import <Foundation/Foundation.h>

@interface NSObject (NotificationAdditions)

- (void)registerForNotification:(NSString *)notificaton selector:(SEL)selector;

- (void)unregisterForNotification:(NSString *)notification;

- (void)unregisterForNotifications;

@end

@interface NSNotificationCenter (NotificationAdditions)

+ (void)postNotification:(NSString *)notification;

+ (void)postNotificationToMainThread:(NSString *)notification;

+ (void)postNotification:(NSString *)notification withObject:(id)object;

+ (void)postNotificationToMainThread:(NSString *)notification withObject:(id)object;

+ (void)postNotification:(NSString *)notification withObject:(id)object userInfo:(NSDictionary *)userInfo;

+ (void)postNotificationToMainThread:(NSString *)notification withObject:(id)object userInfo:(NSDictionary *)userInfo;

+ (void)postNotification:(NSString *)notification userInfo:(NSDictionary *)userInfo;

+ (void)postNotificationToMainThread:(NSString *)notification userInfo:(NSDictionary *)userInfo;

@end
