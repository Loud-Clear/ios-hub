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

#import <Realm/Realm.h>
#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMObjectBase_Dynamic.h>
#import "CCSafeRLMObjectProxy.h"

@implementation CCSafeRLMObjectProxy
{
    id _primaryKey;
    NSString *_className;
    RLMRealmConfiguration *_realmConfiguration;

    RLMRealm *_lastRealm;
    RLMObject *_lastObject;
}

- (instancetype)initWithRLMObject:(RLMObject *)object;
{
    RLMObjectSchema *schema = [object objectSchema];

    NSParameterAssert(schema.primaryKeyProperty);

    _className = schema.className;
    _primaryKey = [object valueForKey:schema.primaryKeyProperty.name];

    _lastObject = object;
    _lastRealm = RLMObjectBaseRealm(object);
    _realmConfiguration = _lastRealm.configuration;

    return self;
}

- (id)proxyTarget
{
    RLMRealm *realmForCurrentThread = [RLMRealm realmWithConfiguration:_realmConfiguration error:nil];
    if (realmForCurrentThread == _lastRealm) {
        return _lastObject;
    } else {
        _lastRealm = realmForCurrentThread;
        _lastObject = [_lastRealm objectWithClassName:_className forPrimaryKey:_primaryKey];
        return _lastObject;
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [NSClassFromString(_className) instanceMethodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:[self proxyTarget]];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [[self proxyTarget] conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [[self proxyTarget] respondsToSelector:aSelector];
}

- (NSString *)description
{
    return [[self proxyTarget] description];
}

- (NSString *)debugDescription
{
    return [[self proxyTarget] debugDescription];
}

- (BOOL)isThreadSafe
{
    return YES;
}

- (instancetype)realmCopy
{
    return [self proxyTarget];
}

@end