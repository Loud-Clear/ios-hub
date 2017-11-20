////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2017 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@protocol CCImageServiceTag <NSObject>

/// Non-nil identifier is required.
+ (NSString *)tagIdentifier;

+ (id<CCImageServiceTag>)tagFromData:(NSData *)data;
+ (NSData *)tagToData:(id<CCImageServiceTag>)tag;

- (NSComparisonResult)compare:(id<CCImageServiceTag>)otherTag;

@optional
- (NSString *)description;

@end
