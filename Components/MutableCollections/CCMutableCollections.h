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

@interface NSDictionary (MutableDictionary)

/// If self is NSMutableDictionary, will return self, otherwise will return mutable copy of self.
- (NSMutableDictionary *)mutableDictionary;

@end

@interface NSArray (MutableArray)

- (NSMutableArray *)mutableArray;

@end
