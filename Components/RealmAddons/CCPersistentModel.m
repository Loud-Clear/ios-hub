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

#import <objc/runtime.h>
#import "CCPersistentModel.h"
#import "CCPersistentId.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "CCCollectionSerialization.h"
#import "CCMacroses.h"

@implementation CCPersistentModel

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[ ];
}

+ (NSArray *)serializedProperties
{
    return @[ ];
}

- (void)beforeAddOrUpdate:(RLMRealm *)realm
{

}

+ (instancetype)createInDefaultRealmWithValue:(id)value
{
    return (id)[super createInDefaultRealmWithValue:[self processedValueFromValue:value]];
}

+ (instancetype)createInRealm:(RLMRealm *)realm withValue:(id)value
{
    return [self createInRealm:realm withValue:[self processedValueFromValue:value]];
}

+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withValue:(NSDictionary *)value
{
    return (id)[super createOrUpdateInRealm:realm withValue:[self processedValueFromValue:value]];
}

- (instancetype)initWithValue:(id)value
{
    return (id)[super initWithValue:[[self class] processedValueFromValue:value]];
}

+ (id)processedValueFromValue:(id)value
{
    NSDictionary *processedValue = value;

    NSArray *serializedProperties = [self serializedProperties];
    if ([value isKindOfClass:[NSDictionary class]] && [serializedProperties count] > 0) {
        NSMutableDictionary *mutableValue = [(NSDictionary *)value mutableCopy];

        [value enumerateKeysAndObjectsUsingBlock:^(id key, id<CCDatabaseJSONSerialization> obj, BOOL *stop) {
            if ([serializedProperties containsObject:key]) {
                [mutableValue removeObjectForKey:key];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[obj serializeToJSONObject] options:0 error:nil];
                mutableValue[CCDataPropertyNameFromName(key)] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }];

        processedValue = mutableValue;
    }

    return processedValue;
}
//-------------------------------------------------------------------------------------------
#pragma mark - Auto serialized data properties
//-------------------------------------------------------------------------------------------

static NSString *CCIvarNameFromProperty(NSString *propertyName)
{
    return [NSString stringWithFormat:@"_%@", propertyName];
}

static NSString *CCPropertyNameFromSetter(NSString *setter)
{
    NSCAssert([setter length] >= 4, @"Incorrect setter: %@", setter);
    NSString *propertyName = [setter stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange([propertyName length] - 1, 1) withString:@""];
    return [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[propertyName substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
}

static NSString *CCPropertyNameFromGetter(NSString *getter)
{
    return getter;
}

static NSString *CCDefaultPropertyGetter(id self, SEL _cmd)
{
    NSString *propertyName = CCPropertyNameFromGetter(NSStringFromSelector(_cmd));
    NSString *ivarName = CCIvarNameFromProperty(propertyName);
    return GetAssociatedObjectFromObject(self, NSSelectorFromString(ivarName));;
}

static void CCDefaultPropertySetter(id self, SEL _cmd, NSString *newName)
{
    NSString *propertyName = CCPropertyNameFromSetter(NSStringFromSelector(_cmd));
    NSString *ivarName = CCIvarNameFromProperty(propertyName);
    SetAssociatedObjectToObject(self, NSSelectorFromString(ivarName), newName);
}

NSString *CCDataPropertyNameFromName(NSString *propertyName)
{
    return [NSString stringWithFormat:@"json_%@", propertyName];
}

static NSString *CCGetterNameFromPropertyName(NSString *propertyName)
{
    return propertyName;
}

static NSString *CCSetterNameFromPropertyName(NSString *propertyName)
{
    NSString *alteredCapName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                     withString:[[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString]];

    return [NSString stringWithFormat:@"set%@:", alteredCapName];
}

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

static id CCObjectPropertyGetter(id self, SEL _cmd)
{
    NSString *propertyName = CCPropertyNameFromGetter(NSStringFromSelector(_cmd));
    SEL key = NSSelectorFromString(CCIvarNameFromProperty(propertyName));

    id ivar = GetAssociatedObjectFromObject(self, key);
    if (!ivar) {

        TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:[self class]];
        NSCParameterAssert(IsClass(type.classOrProtocol));

        //Getting value from storage
        NSString *dataPropertyName = CCDataPropertyNameFromName(propertyName);
        NSString *getterSelectorName = CCGetterNameFromPropertyName(dataPropertyName);
        SEL getterSelector = NSSelectorFromString(getterSelectorName);
        Method getter = class_getInstanceMethod([self class], getterSelector);
        NSString *(*getterImpl)(id, SEL) = (NSString *(*)(id, SEL))method_getImplementation(getter);
        NSString *jsonString = getterImpl(self, getterSelector);

        //De-serialize value and cache
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            ivar = [(id<CCDatabaseJSONSerialization>)[type.typeBeingDescribed alloc] initWithJSONObject:jsonObject];
            SetAssociatedObject(key, ivar);
        }
    }
    return ivar;
}

static void CCObjectPropertySetter(id self, SEL _cmd, id newObject)
{
    if (!newObject) {
        return;
    }

    NSString *propertyName = CCPropertyNameFromSetter(NSStringFromSelector(_cmd));
    SEL key = NSSelectorFromString(CCIvarNameFromProperty(propertyName));

    SetAssociatedObject(key, newObject);

    id jsonObject = [newObject serializeToJSONObject];
    id jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];


    NSString *dataPropertyName = CCDataPropertyNameFromName(propertyName);
    NSString *setterSelectorName = CCSetterNameFromPropertyName(dataPropertyName);
    SEL setterSelector = NSSelectorFromString(setterSelectorName);
    Method setter = class_getInstanceMethod([self class], setterSelector);
    void(*setterImpl)(id, SEL, NSString *) = (void(*)(id, SEL, NSString *))method_getImplementation(setter);

    setterImpl(self, setterSelector, jsonString);
}

//-------------------------------------------------------------------------------------------
#pragma mark -
//-------------------------------------------------------------------------------------------

+ (void)initialize
{
    NSArray *properties = [self serializedProperties];

    if ([properties count] > 0) {
        for (NSString *propertyName in properties) {
            [self addStorageForProperty:propertyName];
            [self overrideSerializationForProperty:propertyName];
        }
        [self ignoreSerializedProperties];
    }
}

+ (void)addStorageForProperty:(NSString *)propertyName
{
    NSString *alteredName = CCDataPropertyNameFromName(propertyName);

    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t attrs[] = { type };
    class_addProperty(self, [alteredName cStringUsingEncoding:NSUTF8StringEncoding], attrs, 1);

    class_addMethod(self, NSSelectorFromString(CCGetterNameFromPropertyName(alteredName)), (IMP)CCDefaultPropertyGetter, "@@:");
    class_addMethod(self, NSSelectorFromString(CCSetterNameFromPropertyName(alteredName)), (IMP)CCDefaultPropertySetter, "v@:@");
}

+ (void)overrideSerializationForProperty:(NSString *)propertyName
{
    class_addMethod(self, NSSelectorFromString(CCGetterNameFromPropertyName(propertyName)), (IMP)CCObjectPropertyGetter, "@@:");
    class_addMethod(self, NSSelectorFromString(CCSetterNameFromPropertyName(propertyName)), (IMP)CCObjectPropertySetter, "v@:@");
}

+ (void)ignoreSerializedProperties
{
    Method ignoredProperties = class_getClassMethod(self, @selector(ignoredProperties));

    NSArray *(*originalImp)(id, SEL) = (NSArray *(*)(id , SEL))method_getImplementation(ignoredProperties);

    method_setImplementation(ignoredProperties, imp_implementationWithBlock(^(id target, SEL sel){
        NSMutableSet *result = [NSMutableSet new];
        [result addObjectsFromArray:originalImp(target, sel)];
        [result addObjectsFromArray:[target serializedProperties]];
        return [result allObjects];
    }));
}

@end
