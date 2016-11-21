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
#import <CTObjectiveCRuntimeAdditions/CTBlockDescription.h>
#import <Typhoon/TyphoonTypeDescriptor.h>
#import "CCModuleFactoryImplementation.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonStoryboard.h"
#import "CCModuleURLParser.h"
#import "CCTransitionHandler.h"
#import "CCMacroses.h"
#import "UIViewController+CCTransitionHandler.h"

@implementation CCModuleFactoryImplementation

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (id<CCModule>)moduleForURL:(NSURL *)url thenChainUsingBlock:(ССModuleLinkBlock)block
{
    id<CCModule> module = [self moduleForURL:url];

    if (block) {
        [self tryCallBlock:block forModule:module];
    }

    return module;
}

- (id<CCModule>)moduleForURL:(NSURL *)url
{
    NSError *error = nil;
    CCModuleURLParserResult *result = [CCModuleURLParser parseURL:url error:&error];
    if (result) {
        id<CCModule> controller = nil;
        if (result.storyboardName) {
            controller = [self moduleForStoryboard:result.storyboardName identifier:result.controllerName];
        } else if (result.definitionKey) {
            controller = [self moduleForDefinitionKey:result.definitionKey];
        } else {
            controller = [self moduleForViewControllerClass:NSClassFromString(result.controllerName)];
        }

        id<CCGeneralModuleInput> input = [controller moduleInput];
        if (input && [input respondsToSelector:@selector(setInputParameters:)] && [result.parameters count] > 0) {
            [input setInputParameters:result.parameters];
        }

        return controller;

    } else {
        DDLogError(@"Error while URL parsing: %@", error);
    }
    return nil;
}

- (id<CCModule>)moduleForStoryboard:(NSString *)storyboardName
                         identifier:(NSString *)identifier
{
    TyphoonStoryboard *storyboard = [TyphoonStoryboard storyboardWithName:storyboardName
                                                                  factory:self.factory bundle:nil];
    UIViewController *controller = nil;
    if (identifier) {
        controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    } else {
        controller = [storyboard instantiateInitialViewController];
    }
    return (id)controller;
}

- (id<CCModule>)moduleForViewControllerClass:(Class)clazz
{
    id module = [self.factory componentForType:clazz];
    if (!module) {
        module = [clazz new];
    }
    return module;
}

- (id<CCModule>)moduleForDefinitionKey:(NSString *)definitionKey
{
    return [self.factory componentForKey:definitionKey];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)tryCallBlock:(ССModuleLinkBlock)block forModule:(id<CCModule>)module
{
    id<CCGeneralModuleInput> moduleInput = [module moduleInput];
    if (!moduleInput) {
        DDLogError(@"Can't find moduleInput for module %@. Is it VIPER module?", module);
        return;
    }

    CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:block];
    if (blockDescription.blockSignature.numberOfArguments < 2) {
        DDLogError(@"Block has too few arguments!");
        return;
    }

    NSString *moduleOutputTypeOriginal = [NSString stringWithCString:[blockDescription.blockSignature getArgumentTypeAtIndex:1] encoding:NSUTF8StringEncoding];
    const char *moduleOutputTypeFixedCString = [[@"T" stringByAppendingString:moduleOutputTypeOriginal] UTF8String];
    TyphoonTypeDescriptor *typeDescriptor = [TyphoonTypeDescriptor descriptorWithEncodedType:moduleOutputTypeFixedCString];
    Protocol *moduleInputProtocol = NSProtocolFromString(typeDescriptor.declaredProtocol);

    if (!moduleInputProtocol || [moduleInput conformsToProtocol:moduleInputProtocol])
    {
        id<CCGeneralModuleOutput> moduleOutput = block(moduleInput);

        if ([moduleInput respondsToSelector:@selector(setModuleOutput:)]) {
            [moduleInput setModuleOutput:moduleOutput];
        }
    } else {
        DDLogError(@"Module %@ doesn't conform to expected protocol %@!", NSStringFromClass([moduleInput class]), NSStringFromProtocol(moduleInputProtocol));
        NSAssert(NO, nil);
    }
}

@end
