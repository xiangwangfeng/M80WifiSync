//
//  M80WeakProxy.m
//  M80Kit
//
//  Created by amao on 6/20/14.
//  Copyright (c) 2014 amao. All rights reserved.
//
//Fork From FLAnimatedImage https://github.com/Flipboard/FLAnimatedImage

#import "M80WeakProxy.h"

@interface M80WeakProxy ()
@property (nonatomic,weak)  id target;
@end

@implementation M80WeakProxy

+ (instancetype)weakProxyForObject:(id)object
{
    M80WeakProxy *instance = [[M80WeakProxy alloc] init];
    instance.target = object;
    return instance;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // Fallback for when target is nil. Don't do anything, just return 0/NULL/nil.
    // The method signature we've received to get here is just a dummy to keep `doesNotRecognizeSelector:` from firing.
    // We can't really handle struct return types here because we don't know the length.
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // We only get here if `forwardingTargetForSelector:` returns nil.
    // In that case, our weak target has been reclaimed. Return a dummy method signature to keep `doesNotRecognizeSelector:` from firing.
    // We'll emulate the Obj-c messaging nil behavior by setting the return value to nil in `forwardInvocation:`, but we'll assume that the return value is `sizeof(void *)`.
    // Other libraries handle this situation by making use of a global method signature cache, but that seems heavier than necessary and has issues as well.
    // See https://www.mikeash.com/pyblog/friday-qa-2010-02-26-futures.html and https://github.com/steipete/PSTDelegateProxy/issues/1 for examples of using a method signature cache.
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}



@end
