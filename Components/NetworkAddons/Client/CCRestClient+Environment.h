//
//  CCRestClient+Environment.h
//  Fernwood
//
//  Created by Aleksey Garbarev on 25/05/2018.
//  Copyright © 2018 Loud & Clear Pty Ltd. All rights reserved.
//

#import "CCRestClient.h"
#import "CCEnvironment.h"

@interface CCRestClient (Environment)

- (void)setBaseUrlFromEnvironment:(CCEnvironment *)environment keyPath:(NSString *)keyPath;

@end
