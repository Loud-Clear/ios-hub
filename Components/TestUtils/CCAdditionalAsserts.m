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

#import "CCAdditionalAsserts.h"

@implementation CCAdditionalAsserts

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance conformToProtocols:(Protocol *)firstProtocol, ...
{
    va_list args;
    va_start(args, firstProtocol);
    id protocolOrNil = firstProtocol;
    do {
        if (protocolOrNil) {
            if (![instance conformsToProtocol:protocolOrNil]) {
                [self fail:test at:place with:@"%@ doesn't conform to protocol %@", NSStringFromClass([instance class]),
                      NSStringFromProtocol(protocolOrNil)];
                return;
            }
        }
        protocolOrNil = va_arg(args, Protocol *);
    } while (protocolOrNil != nil);
    va_end(args);
}

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance kindOfClass:(Class)clazz
{
    if (![instance isKindOfClass:clazz]) {
        [self fail:test at:place with:@"%@ is not kind of class %@", NSStringFromClass([instance class]),
              NSStringFromClass(clazz)];
    }
}

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance hasDependency:(SEL)dependencySelector withKind:(id)classOrProtocolOrNil
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id dependencyValue = [instance performSelector:dependencySelector];
#pragma clang diagnostic pop

    if (!dependencyValue) {
        [self fail:test at:place with:@"%@.%@ dependency expected to be non-null", NSStringFromClass([instance class]),
              NSStringFromSelector(dependencySelector)];
    }

    if (classOrProtocolOrNil) {
        BOOL isClass = class_isMetaClass(object_getClass(classOrProtocolOrNil));
        BOOL isProtocol = object_getClass(classOrProtocolOrNil) == object_getClass(@protocol(NSObject));
        if (isClass && ![dependencyValue isKindOfClass:classOrProtocolOrNil]) {
            [self fail:test at:place with:@"%@.%@ dependency is not kind of class %@",
                  NSStringFromClass([instance class]), NSStringFromSelector(dependencySelector),
                  NSStringFromClass(classOrProtocolOrNil)];
        }
        else if (isProtocol && ![dependencyValue conformsToProtocol:classOrProtocolOrNil]) {
            [self fail:test at:place with:@"%@.%@ dependency doesn't conform to protocol %@",
                  NSStringFromClass([instance class]), NSStringFromSelector(dependencySelector),
                  NSStringFromProtocol(classOrProtocolOrNil)];
        }
    }
}

+ (void)fail:(XCTestCase *)test at:(CCFileAndLine)place with:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4)
{
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSString *filePathString = [NSString stringWithUTF8String:place.filePath];

    [test recordFailureWithDescription:description inFile:filePathString atLine:place.lineNumber expected:YES];
}


@end
