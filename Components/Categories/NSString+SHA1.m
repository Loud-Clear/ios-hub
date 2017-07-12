//
//  NSString+SHA1.m
//
//  Created by Ivan Zezyulya on 27.02.12.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@implementation NSString (SHA1)

- (NSString *) sha1
{
    if (self.length == 0) {
        return nil;
    }

    if (CC_SHA1_DIGEST_LENGTH != 20) {
        NSAssert(NO, nil);
        return nil;
    }

    const char *cstring = [self UTF8String];

    unsigned char buf[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(cstring, (CC_LONG)strlen(cstring), buf);

    NSString *result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            buf[0],  buf[1],  buf[2],  buf[3],  buf[4],  buf[5],  buf[6],  buf[7],  buf[8],  buf[9],
            buf[10], buf[11], buf[12], buf[13], buf[14], buf[15], buf[16], buf[17], buf[18], buf[19]
    ];

    return result;
}

@end
