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

#import "NSString+CCGenWord.h"
#import "CCMacroses.h"

@implementation NSString (CCGenWord)

+ (NSString *)generateWord:(NSInteger)approxLength
{
    let consonantLetters = @"bcdfghklmnpqrstvwxz";
    let vowelLetters = @"aeijouy";

    let length = approxLength/2 + arc4random_uniform((u_int32_t)approxLength);

    let randomString = [NSMutableString stringWithCapacity:(u_int32_t)length];

    for (int i = 0; i < length; i++) {
        let letters = (i % 2) ? vowelLetters : consonantLetters;
        [randomString appendFormat:@"%c", [letters characterAtIndex:arc4random_uniform((unsigned int)[letters length])]];
    }

    return [randomString capitalizedString];
}

+ (NSString *)generateSentence:(NSInteger)approxWords
{
    let words = [NSMutableArray<NSString *> new];

    let wordsCount = approxWords/2 + arc4random_uniform((u_int32_t)approxWords);

    for (NSInteger i = 0; i < wordsCount; i++) {
        var word = [self generateWord:6];
        if (i == 0) {
            word = [word capitalizedString];
        }
        [words addObject:word];
    }

    let result = [words componentsJoinedByString:@" "];
    return result;
}

+ (NSString *)generateSentences:(NSInteger)approxSentences
{
    let sentences = [NSMutableArray<NSString *> new];

    let sentencesCount = approxSentences/2 + arc4random_uniform((u_int32_t)approxSentences);

    for (NSInteger i = 0; i < sentencesCount; i++) {
        var sentence = [self generateSentence:7];
        [sentences addObject:sentence];
    }

    let result = [sentences componentsJoinedByString:@". "];
    return result;
}

@end
