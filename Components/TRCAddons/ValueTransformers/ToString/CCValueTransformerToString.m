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

#import "CCValueTransformerToString.h"


@implementation CCValueTransformerToString

- (id)objectFromResponseValue:(id)responseValue error:(NSError **)error
{
    return [responseValue description];
}

- (id)requestValueFromObject:(id)object error:(NSError **)error
{
    return [object description];
}

- (TRCValueTransformerType)externalTypes
{
    return TRCValueTransformerTypeNumber | TRCValueTransformerTypeString;
}

@end
