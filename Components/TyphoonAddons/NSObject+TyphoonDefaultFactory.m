////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Typhoon/TyphoonDefinition.h>
#import "NSObject+TyphoonDefaultFactory.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "Typhoon+Infrastructure.h"
#import "CCMacroses.h"

@implementation NSObject (TyphoonDefaultFactory)

+ (BOOL)isAutoDefinition:(TyphoonDefinition *)definition
{
    NSString *key = [definition key];
    return [key hasPrefix:[NSString stringWithFormat:@"%@_", [self class]]];
}

+ (instancetype)newUsingTyphoon
{
    id result = nil;

    TyphoonComponentFactory *defaultFactory = [TyphoonComponentFactory factoryForResolvingUI];
    if (defaultFactory) {
        NSArray *definitions = [defaultFactory allDefinitionsForType:[self class]];

        if (definitions.count == 1 && [self isAutoDefinition:definitions.firstObject]) {
            definitions = @[];
        }

        switch (definitions.count) {
            case 0:
                result = [self new];
                [defaultFactory inject:result];
                break;
            case 1:
                result = [defaultFactory componentForType:[self class]];
                break;
            default:
                result = [self new];
                DDLogWarn(@"Found more than one definition for class: %@", self);
                break;
        }
    }

    return result;
}

- (void)injectUsingTyphoon
{
    TyphoonComponentFactory *defaultFactory = [TyphoonComponentFactory factoryForResolvingUI];
    [defaultFactory inject:self];
}

+ (instancetype)fromTyphoon
{
    TyphoonComponentFactory *factory = [TyphoonComponentFactory factoryForResolvingUI];
    return [factory componentForType:self];
}

@end
