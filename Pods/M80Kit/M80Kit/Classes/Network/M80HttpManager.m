//
//  M80HttpManager.m
//  M80Kit
//
//  Created by amao on 1/8/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "M80HttpManager.h"

@interface M80HttpManager ()
@property (nonatomic,strong)    NSOperationQueue *queue;
@end

@implementation M80HttpManager
+ (instancetype)sharedManager
{
    static M80HttpManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80HttpManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (M80HttpOperation *)request:(NSURLRequest *)request
                      success:(M80HttpSuccess)success
                      failure:(M80HttpFailure)failure
{
    M80HttpOperation *operation = [[M80HttpOperation alloc] init];
    operation.request = request;
    operation.success = success;
    operation.failure = failure;
    
    [_queue addOperation:operation];
    return operation;
}

@end
