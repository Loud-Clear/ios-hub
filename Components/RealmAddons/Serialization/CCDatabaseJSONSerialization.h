//
//  CCDatabaseSerialization.h
//  iOS Hub
//
//  Created by Aleksey Garbarev on 18/11/2016.
//  Copyright © 2016 Loud & Clear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCDatabaseJSONSerialization

- (id)serializeToJSONObject;

- (id)initWithJSONObject:(id)jsonObject;

@end
