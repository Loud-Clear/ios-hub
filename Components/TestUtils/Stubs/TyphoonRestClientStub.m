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

#import "TyphoonRestClientStub.h"
#import "CCMacroses.h"

@interface TRCResponseStub : NSObject <TRCResponseTrigger>

@property (nonatomic) id response;
@property (nonatomic) NSError *error;
@property (nonatomic) BOOL responseWasSet;


@property (nonatomic, strong) void(^responseBlock)(id, NSError *);

@end

@implementation TRCResponseStub

- (void)responseWith:(id)object error:(NSError *)error
{
    self.response = object;
    self.error = error;
    self.responseWasSet = YES;
    SafetyCall(self.responseBlock, object, error);
}

- (void)setResponseBlock:(void (^)(id, NSError *))responseBlock
{
    _responseBlock = responseBlock;
    if (self.responseWasSet) {
        SafetyCall(_responseBlock, self.response, self.error);
    }
}

@end

@implementation TyphoonRestClientStub
{
    id _responseObject;
    NSError *_error;

    void(^_requestValidationBlock)(id<TRCRequest>request);

    NSMutableDictionary *_perRequestStubs;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _perRequestStubs = [NSMutableDictionary new];
    }

    return self;
}

- (id<TRCResponseTrigger>)stubRequest:(Class)requestClass
{
    TRCResponseStub *stub = [TRCResponseStub new];
    _perRequestStubs[NSStringFromClass(requestClass)] = stub;
    return stub;
}

- (void)stubRequest:(Class)requestClass withResponse:(id)object error:(NSError *)error
{
    id<TRCResponseTrigger> response = [self stubRequest:requestClass];
    [response responseWith:object error:error];
}

- (void)stubWithResponseObject:(id)object error:(NSError *)error
{
    _responseObject = object;
    _error = error;
}

- (void)verifyRequestWithBlock:(void(^)(id<TRCRequest>request))block
{
    _requestValidationBlock = block;
}

- (void)verifyFirstRequestWithBlock:(void(^)(id<TRCRequest>request))block
{
    __weak __typeof(self) weakSelf = self;

    [self verifyRequestWithBlock:^(id<TRCRequest> request) {
        block(request);
        [weakSelf verifyRequestWithBlock:nil];
    }];
}

- (id<TRCProgressHandler>)sendRequest:(id<TRCRequest>)request completion:(void (^)(id result, NSError *error))completion
{
    SafetyCall(_requestValidationBlock, request);

    TRCResponseStub *stub = _perRequestStubs[NSStringFromClass([request class])];
    if (stub) {
        [stub setResponseBlock:^(id response, NSError *error) {
            SafetyCall(completion, response, error);
        }];
    } else {
        SafetyCall(completion, _responseObject, _error);
    }

    return nil;
}

@end
