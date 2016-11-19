//
//  DTModulePromise.h
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "DTGeneralModuleInput.h"
#import "DTGeneralModuleOutput.h"

typedef id(^DTModuleLinkBlock)(id moduleInput);

@protocol DTModulePromise <NSObject>

/**
 * Deprecated - use thenChainToModule:usingBlock: which will also check that module conforms to expected protocol.
 */
- (void)thenChainUsingBlock:(DTModuleLinkBlock)linkBlock;

@end
