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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <XCTest/XCTest.h>


@class OCMArg;

#define XCTAssertKindOfClass(anInstance, expectedClass) [CCAdditionalAsserts assert:self at:CCFileAndLineMake(__FILE__, __LINE__) instance:anInstance kindOfClass:[expectedClass class]]
#define XCTAssertConformsToProtocol(instance, aProtocol) XCTAssertConformsToAllProtocols(instance, aProtocol, nil)
#define XCTAssertConformsToAllProtocols(anInstance, protocols, ...) [CCAdditionalAsserts assert:self at:CCFileAndLineMake(__FILE__, __LINE__) instance:anInstance conformToProtocols: protocols, __VA_ARGS__]
#define XCTAssertDependency(instance, dependencySelector) XCTAssertDependencyWithType(instance, dependencySelector, nil)
#define XCTAssertDependencyWithType(anInstance, dependencySelector, type) [CCAdditionalAsserts assert:self at:CCFileAndLineMake(__FILE__, __LINE__) instance:anInstance hasDependency:@selector(dependencySelector) withKind:type]


typedef struct {
    const char *filePath;
    NSUInteger lineNumber;
} CCFileAndLine;

__unused static CCFileAndLine CCFileAndLineMake(const char *filePath, NSUInteger lineNumber)
{
    return (CCFileAndLine){filePath, lineNumber};
}

@interface CCAdditionalAsserts : NSObject

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance conformToProtocols:(Protocol *)firstProtocol, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance kindOfClass:(Class)clazz;

+ (void)assert:(XCTestCase *)test at:(CCFileAndLine)place instance:(id)instance hasDependency:(SEL)dependencySelector withKind:(id)classOrProtocolOrNil;

@end




