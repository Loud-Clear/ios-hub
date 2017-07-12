//
//  CCTransitionPromise.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import <Typhoon/TyphoonTypeDescriptor.h>
#import "CCTransitionPromise.h"
#import "CTBlockDescription.h"
#import "CCMacroses.h"
#import "CCGeneralPresenter.h"

@interface CCTransitionPromise()

@property (nonatomic, copy) CCModuleLinkBlock linkBlock;
@property (nonatomic) BOOL linkBlockWasSet;
@property (nonatomic) BOOL moduleInputWasSet;

@end

@implementation CCTransitionPromise {
    NSMutableOrderedSet *_postLinkBlocks;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _postLinkBlocks = [NSMutableOrderedSet new];
    }
    return self;
}


- (void)setModuleInput:(id<CCGeneralModuleInput>)moduleInput
{
    _moduleInput = moduleInput;
    self.moduleInputWasSet = YES;
    [self tryLink];
}

- (void)addPostLinkBlock:(void (^)(id<CCGeneralModuleInput> moduleInput, UIViewController *nextViewController))postLinkBlock
{
    [_postLinkBlocks addObject:postLinkBlock];
}

- (void)thenChainUsingBlock:(CCModuleLinkBlock)linkBlock
{
    self.linkBlock = linkBlock;
    self.linkBlockWasSet = YES;
    [self tryLink];
}

- (void)tryLink
{
    if (self.linkBlockWasSet && self.moduleInputWasSet) {
        [self linkModules];
    }
}

- (void)linkModules
{
    if (!self.linkBlock) {
        return;
    }

    CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:self.linkBlock];
    if (blockDescription.blockSignature.numberOfArguments < 2) {
        DDLogError(@"Block has too few arguments!");
        return;
    }

    NSString *moduleOutputTypeOriginal = [NSString stringWithCString:[blockDescription.blockSignature getArgumentTypeAtIndex:1] encoding:NSUTF8StringEncoding];
    const char *moduleOutputTypeFixedCString = [[@"T" stringByAppendingString:moduleOutputTypeOriginal] UTF8String];
    TyphoonTypeDescriptor *typeDescriptor = [TyphoonTypeDescriptor descriptorWithEncodedType:moduleOutputTypeFixedCString];
    Protocol *moduleInputProtocol = NSProtocolFromString(typeDescriptor.declaredProtocol);

    if (moduleInputProtocol && ![_moduleInput conformsToProtocol:moduleInputProtocol]) {
        DDLogError(@"Module %@ doesn't conform to expected protocol %@!", NSStringFromClass([_moduleInput class]), NSStringFromProtocol(moduleInputProtocol));
        NSAssert(NO, nil);
        return;
    }

    id<CCGeneralModuleOutput> moduleOutput = self.linkBlock(self.moduleInput);

    if ([self.moduleInput respondsToSelector:@selector(setModuleOutput:)]) {
        [self.moduleInput setModuleOutput:moduleOutput];
    }

    [self callPostLinkBlocks];
}

- (void)callPostLinkBlocks
{
    for (void(^block)(id, id) in _postLinkBlocks) {
        block(self.moduleInput, self.nextViewController);
    }

    [self callDidConfigure];
}

- (void)callDidConfigure
{
    id<CCGeneralModuleInput> input = self.moduleInput;

    if ([input isKindOfClass:[CCGeneralPresenter class]]) {
        [(CCGeneralPresenter *)input didConfigureModule];
    }
}

- (void)dealloc
{
    // If linkBlock was not set - run post link action anyway (used on openModuleWithURL)

    if (!self.linkBlockWasSet && self.moduleInputWasSet) {
        [self callPostLinkBlocks];
    }
}


@end
