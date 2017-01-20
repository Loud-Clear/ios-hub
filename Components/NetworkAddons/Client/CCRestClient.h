////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonRestClient.h"


@interface CCRestClient : TyphoonRestClient

@property (nonatomic) NSURL *baseUrl;
@property (nonatomic) BOOL logging;
@property (nonatomic) TRCConnectionProxy *sessionInjectingConnection;

+ (NSURLSessionConfiguration *)urlSessionConfiguration;

- (void)setupClient;

@end
