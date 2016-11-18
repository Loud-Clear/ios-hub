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
#import "DTDatabaseJSONSerialization.h"

@interface DTDatabaseDictionary : NSObject <DTDatabaseJSONSerialization>

@property (nonatomic, strong, readonly) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface NSDictionary (DTDatabaseSerialization) <DTDatabaseJSONSerialization>

@end

