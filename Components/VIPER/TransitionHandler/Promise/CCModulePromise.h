//
//  CCModulePromise.h
//  DreamTeam
//
//  Created by Aleksey Garbarev on 13/05/16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCGeneralModuleInput.h"
#import "CCGeneralModuleOutput.h"

typedef id(^CCModuleLinkBlock)(id moduleInput);

@protocol CCModulePromise <NSObject>

/**
 * Deprecated - use thenChainToModule:usingBlock: which will also check that module conforms to expected protocol.
 */
- (void)thenChainUsingBlock:(CCModuleLinkBlock)linkBlock;

@end
