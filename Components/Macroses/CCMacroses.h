////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "EXTScope.h"
#import "CCLogger.h"

#import "CCMacrosesSuppressWarning.h"

#define SafetyCall(block, ...) if((block)) { (block)(__VA_ARGS__); }
#define SafetyCallAfter(seconds, block, ...) if((block)) { dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{(block)(__VA_ARGS__);});}
#define SafetyCallOn(queue, block, ...) if((block)) { dispatch_async(queue, ^{ (block)(__VA_ARGS__); }); }
#define SafetyCallOnMain(block, ...) if((block)) { dispatch_async(dispatch_get_main_queue(), ^{ (block)(__VA_ARGS__); }); }

#define CCSelectorToString(sel) NSStringFromSelector(@selector(sel))

#define CCSetPointer(pointer, ...) if ((pointer)) {*pointer = __VA_ARGS__;}

#define MainQueue dispatch_get_main_queue()
#define QueueHigh dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define QueueDefault dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define QueueLow dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define QueueBackground dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

#define SetAssociatedObject(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#define GetAssociatedObject(key) objc_getAssociatedObject(self, key)

#define SetAssociatedObjectToObject(object, key, value) objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#define GetAssociatedObjectFromObject(object, key) objc_getAssociatedObject(object, key)

#define let __auto_type const
#define var __auto_type


#define CMTime(seconds) CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)
#define RadiansToDegrees(radians) (CGFloat) ((radians) * (180.0 / M_PI))
#define DegreesToRadians(degrees) (CGFloat) ((degrees) / 180.0 * M_PI)
#define NSValueFromPrimitive(primitive) ([NSValue value:&primitive withObjCType:@encode(typeof(primitive))])

#define CCIOSVersionGreaterThan(version)           ([UIDevice.currentDevice.systemVersion compare:@ #version options:NSNumericSearch] == NSOrderedDescending)
#define CCIOSVersionGreaterThanOrEqualTo(version)  ([UIDevice.currentDevice.systemVersion compare:@ #version options:NSNumericSearch] != NSOrderedAscending)
#define CCIOSVersionLessThan(version)              ([UIDevice.currentDevice.systemVersion compare:@ #version options:NSNumericSearch] == NSOrderedAscending)
#define CCIOSVersionLessThanOrEqualTo(version)     ([UIDevice.currentDevice.systemVersion compare:@ #version options:NSNumericSearch] != NSOrderedDescending)


#define CC_IMPLEMENT_SHARED_SINGLETON(className) \
    static className *instance; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [className new]; \
    }); \
    return instance;
