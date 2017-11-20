////////////////////////////////////////////////////////////////////////////////
//
//  LOUD&CLEAR
//  Copyright 2016 Loud&Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud&Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

@import Foundation;

@interface NSString (CCGenWord)

+ (NSString *)generateWord:(NSInteger)approxLength;
+ (NSString *)generateSentence:(NSInteger)approxWords;
+ (NSString *)generateSentences:(NSInteger)approxSentences;

@end
