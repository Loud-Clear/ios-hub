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

#import <Typhoon/TyphoonIntrospectionUtils.h>
#import "DTNavigatorContext.h"

@implementation DTNavigatorContext
{
    NSMutableDictionary *_objectsDictionary;
    NSMutableArray *_objects;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray new];
        _objectsDictionary = [NSMutableDictionary new];
    }

    return self;
}

+ (instancetype)contextWithObjects:(NSArray *)objects
{
    DTNavigatorContext *result = [DTNavigatorContext new];
    [result->_objects addObjectsFromArray:objects];
    return result;
}

+ (instancetype)contextWithObjectsDictionary:(NSDictionary *)objects
{
    DTNavigatorContext *result = [DTNavigatorContext new];
    [result->_objectsDictionary addEntriesFromDictionary:objects];
    return result;
}

- (void)addObject:(id)object
{
    [_objects addObject:object];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    _objectsDictionary[key] = object;
}

- (id)objectForKey:(NSString *)key
{
    return _objectsDictionary[key];
}

- (id)objectForType:(id)classOrProtocol
{
    id testBlock = ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (IsClass(classOrProtocol)) {
            return [obj isKindOfClass:classOrProtocol];
        } else if (IsProtocol(classOrProtocol)) {
            return [obj conformsToProtocol:classOrProtocol];
        }
        return NO;
    };

    NSUInteger index = [_objects indexOfObjectPassingTest:testBlock];
    if (index != NSNotFound) {
        return _objects[index];
    }

    NSArray *dictObjects = [_objectsDictionary allValues];
    index = [dictObjects indexOfObjectPassingTest:testBlock];
    if (index != NSNotFound) {
        return dictObjects[index];
    }

    return nil;
}


@end
