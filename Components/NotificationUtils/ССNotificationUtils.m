#import "ССNotificationUtils.h"

@implementation NSObject (NotificationAdditions)

- (void)registerForNotification:(NSString *)notificaton selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificaton object:nil];
}

- (void)unregisterForNotification:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:nil];
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation NSNotificationCenter (NotificationAdditions)

+ (void)postNotification:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

+ (void)postNotificationToMainThread:(NSString *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
    });
}

+ (void)postNotification:(NSString *)notification withObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object];
}

+ (void)postNotificationToMainThread:(NSString *)notification withObject:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object];
    });
}

+ (void)postNotification:(NSString *)notification withObject:(id)object userInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
}

+ (void)postNotificationToMainThread:(NSString *)notification withObject:(id)object userInfo:(NSDictionary *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
    });
}

+ (void)postNotification:(NSString *)notification userInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:userInfo];
}

+ (void)postNotificationToMainThread:(NSString *)notification userInfo:(NSDictionary *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:userInfo];
    });
}

@end
