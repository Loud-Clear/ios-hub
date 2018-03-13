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

#import "CCBlockHandler.h"
#import "TyphoonTypeDescriptor.h"
#import "CCMacroses.h"


@interface NSObject (PerformSelectorWith3Objects)
- (id)cc_performSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;
@end

@implementation NSObject (PerformSelectorWith3Objects)

- (id)cc_performSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3
{
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [inv setSelector:selector];

    [inv setArgument:&(object1) atIndex:2];
    [inv setArgument:&(object2) atIndex:3];
    [inv setArgument:&(object3) atIndex:4];

    [inv invokeWithTarget:self];

    id retValue = nil;
    if (inv.methodSignature.methodReturnLength != 0) {
        [inv getReturnValue:&retValue];
    }
    return retValue;
}

@end


@implementation CCBlockHandler

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);

    @weakify(target);
    dispatch_block_t block = ^{
        @strongify(target);
        if ([target respondsToSelector:selector]) {
            CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target performSelector:selector];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}

+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector context:(id)context
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);
    if (context) {
        [self checkThatTargets:target selectorParameter:selector atIndex:0 isOfType:[context class]];
    }

    @weakify(target);
    @weakify(context);
    dispatch_block_t block = ^{
        @strongify(target);
        @strongify(context);
        if ([target respondsToSelector:selector]) {
            CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target performSelector:selector withObject:context];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}

+ (dispatch_block_t)withTarget:(id)target action:(SEL)selector context:(id)context1 context:(id)context2
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);
    if (context1) {
        [self checkThatTargets:target selectorParameter:selector atIndex:0 isOfType:[context1 class]];
    }
    if (context2) {
        [self checkThatTargets:target selectorParameter:selector atIndex:1 isOfType:[context2 class]];
    }

    @weakify(target);
    @weakify(context1);
    @weakify(context2);
    dispatch_block_t block = ^{
        @strongify(target);
        @strongify(context1);
        @strongify(context2);
        if ([target respondsToSelector:selector]) {
            CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target performSelector:selector withObject:context1 withObject:context2];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}


+ (CCBlockHandlerParamBlock)withParamWithTarget:(id)target action:(SEL)selector
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);

    @weakify(target);
    CCBlockHandlerParamBlock block = ^(id param){
        @strongify(target);
        if ([target respondsToSelector:selector])
        {
            if (param) {
                [self checkThatTargets:target selectorParameter:selector atIndex:0 isOfType:[param class]];
            }

                    CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target performSelector:selector withObject:param];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}

+ (CCBlockHandler2ParamBlock)with2ParamsWithTarget:(id)target action:(SEL)selector
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);

    @weakify(target);
    CCBlockHandler2ParamBlock block = ^(id param1, id param2){
        @strongify(target);
        if ([target respondsToSelector:selector])
        {
            if (param1) {
                [self checkThatTargets:target selectorParameter:selector atIndex:0 isOfType:[param1 class]];
            }
            if (param2) {
                [self checkThatTargets:target selectorParameter:selector atIndex:1 isOfType:[param2 class]];
            }

                    CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target performSelector:selector withObject:param1 withObject:param2];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}

+ (CCBlockHandler3ParamBlock)with3ParamsWithTarget:(id)target action:(SEL)selector
{
    NSParameterAssert(target);
    NSAssert([target respondsToSelector:selector], nil);

    @weakify(target);
    CCBlockHandler3ParamBlock block = ^(id param1, id param2, id param3){
        @strongify(target);
        if ([target respondsToSelector:selector])
        {
            if (param1) {
                [self checkThatTargets:target selectorParameter:selector atIndex:0 isOfType:[param1 class]];
            }
            if (param2) {
                [self checkThatTargets:target selectorParameter:selector atIndex:1 isOfType:[param2 class]];
            }
            if (param3) {
                [self checkThatTargets:target selectorParameter:selector atIndex:2 isOfType:[param3 class]];
            }

                    CC_WARNING_MUTE_PERFORM_SELECTOR_LEAKS
            [target cc_performSelector:selector withObject:param1 withObject:param2 withObject:param3];
            CC_WARNING_MUTE_END
        }
    };

    return block;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

+ (void)checkThatTargets:(id)target selectorParameter:(SEL)selector atIndex:(NSUInteger)parameterIndex isOfType:(Class)cls
{
    parameterIndex += 2;

    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (parameterIndex >= [signature numberOfArguments]) {
        return;
    }

    const char *encodedArgumentType = [signature getArgumentTypeAtIndex:parameterIndex];
    encodedArgumentType = [[NSString stringWithFormat:@"T%s", encodedArgumentType] UTF8String];
    TyphoonTypeDescriptor *typeDescriptor = [TyphoonTypeDescriptor descriptorWithEncodedType:encodedArgumentType];

    Class targetClass = typeDescriptor.typeBeingDescribed;
    if (targetClass && ![targetClass isKindOfClass:cls]) {
        DDLogError(@"Unexpected argument type in definition of -[%@ %@]: expected \"%@\", got \"%@\".",
                NSStringFromClass([target class]), NSStringFromSelector(selector), NSStringFromClass(cls), NSStringFromClass(targetClass));
        NSAssert(NO, nil);
    }
}

@end
