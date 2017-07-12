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
#import "CCDatabaseJSONSerialization.h"

@interface NSDictionary (CCCollectionSerialization) <CCDatabaseJSONSerialization>

@end

@interface NSArray (CCCollectionSerialization) <CCDatabaseJSONSerialization>

@end

