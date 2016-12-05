#import "ССNotificationUtils.h"
#import <NSObject+DeallocNotification.h>
#import "CCMacroses.h"
#import <objc/runtime.h>


@implementation NSObject (NotificationAdditions)

- (void)registerForNotification:(NSString *)notificaton selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificaton object:nil];

    [self unregisterOnDeallocIfNeeded];
}

- (void)unregisterOnDeallocIfNeeded
{
    NSOperatingSystemVersion ios9 = (NSOperatingSystemVersion){9, 0, 0};
    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9]) {
        NSNumber *isUnregisterListening = GetAssociatedObjectFromObject(self, "unregister_notifications");
        if (!isUnregisterListening) {
            __weak __typeof(self) weakSelf = self;
            [self setDeallocNotificationWithKey:"ССNotificationUtils" andBlock:^{
                [weakSelf unregisterForNotifications];
            }];
            SetAssociatedObjectToObject(self, "unregister_notifications", @YES);
        }
    }
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
