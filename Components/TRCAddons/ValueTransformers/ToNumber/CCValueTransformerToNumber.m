//
//  CCValueTransformerToNumber.m
//  DreamTeam
//
//  Created by Leonid on 02.08.16.
//  Copyright © 2016 FanHub. All rights reserved.
//

#import "CCValueTransformerToNumber.h"

@implementation CCValueTransformerToNumber

- (id)objectFromResponseValue:(id)responseValue error:(NSError **)error
{
	return @([responseValue integerValue]);
}

- (id)requestValueFromObject:(id)object error:(NSError **)error
{
	return @([object integerValue]);
}

- (TRCValueTransformerType)externalTypes
{
	return TRCValueTransformerTypeString | TRCValueTransformerTypeNumber;
}

@end
