//
//  DTTransitionPromise.m
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import <Typhoon/TyphoonTypeDescriptor.h>
#import "DTTransitionPromise.h"
#import "CTBlockDescription.h"
#import "DTMacroses.h"

@interface DTTransitionPromise()

@property (nonatomic, copy) DTModuleLinkBlock linkBlock;
@property (nonatomic) BOOL linkBlockWasSet;
@property (nonatomic) BOOL moduleInputWasSet;

@end

@implementation DTTransitionPromise {
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


- (void)setModuleInput:(id<DTGeneralModuleInput>)moduleInput
{
    _moduleInput = moduleInput;
    self.moduleInputWasSet = YES;
    [self tryLink];
}

- (void)addPostLinkBlock:(void (^)(id<DTGeneralModuleInput> moduleInput, UIViewController *nextViewController))postLinkBlock
{
    [_postLinkBlocks addObject:postLinkBlock];
}

- (void)thenChainUsingBlock:(DTModuleLinkBlock)linkBlock
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

    id<DTGeneralModuleOutput> moduleOutput = self.linkBlock(self.moduleInput);

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
}

- (void)dealloc
{
    // If linkBlock was not set - run post link action anyway (used on openModuleWithURL)

    if (!self.linkBlockWasSet && self.moduleInputWasSet) {
        [self callPostLinkBlocks];
    }
}


@end
