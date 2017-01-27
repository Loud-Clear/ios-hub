//
//  CCValueTransformerUrl.m
//  DreamTeam
//
//  Created by Leonid on 08.09.16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCValueTransformerUrl.h"

@implementation CCValueTransformerUrl

- (NSURL *)objectFromResponseValue:(NSString *)responseValue error:(NSError **)error
{
	return [NSURL URLWithString:responseValue];
}

- (NSString *)requestValueFromObject:(NSURL *)object error:(NSError **)error
{
	return [object absoluteString];
}

@end
