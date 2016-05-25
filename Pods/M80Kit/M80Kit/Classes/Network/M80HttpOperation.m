//
//  M80HttpOperation.m
//  M80Kit
//
//  Created by amao on 1/8/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "M80HttpOperation.h"


@interface M80HttpThread : NSObject
@end

@implementation M80HttpThread
+ (NSThread *)thread
{
    static NSThread *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(threadStart:)
                                             object:nil];
        [instance start];
    });
    return instance;
}

+ (void)threadStart:(id)sender
{
    @autoreleasepool
    {
        [[NSThread currentThread] setName:@"com.m80.http.thread"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

@end

@interface M80HttpOperation ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,strong)    NSMutableData   *data;
@property (nonatomic,strong)    NSURLConnection *connection;
@end

@implementation M80HttpOperation

- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)main
{
    @synchronized(self)
    {
        if (self.isCancelled)
        {
            return;
        }
        
        if (_request == nil ||
            ![NSURLConnection canHandleRequest:_request])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.failure)
                {
                    NSError *error = [NSError errorWithDomain:@"M80HttpDomain"
                                                         code:M80HttpCodeInvalidRequest
                                                     userInfo:nil];
                    self.failure(self,error);
                }
            });
            return;
        }
        
        
        [self performSelector:@selector(reqeust:)
                     onThread:[M80HttpThread thread]
                   withObject:nil
                waitUntilDone:NO];
    }
}

- (void)cancel
{
    @synchronized(self)
    {
        if (![self isFinished] && ![self isCancelled])
        {
            [super cancel];
            [self cancelConnection];
        }
    }
}

- (void)cancelConnection
{
    [self.connection cancel];
    self.connection = nil;
}


- (void)reqeust:(id)sender
{
    @synchronized(self)
    {
        self.connection = [NSURLConnection connectionWithRequest:self.request
                                                        delegate:self];
    }
}


#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    _error = error;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.failure)
        {
            self.failure(self,self.error);
        }
    });
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        _response   = (NSHTTPURLResponse *)response;
        _statusCode = [_response statusCode];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"M80HttpDomain"
                                             code:M80HttpCodeInvalidResponse
                                         userInfo:nil];
        @synchronized(self)
        {
            [self cancelConnection];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.failure)
            {
                self.failure(self,error);
            }
        });
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_data == nil)
    {
        _data = [NSMutableData data];
    }
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.success)
        {
            self.success(self,self.data);
        }
    });
}

#pragma mark - Description
- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"url %@ method %@ code %zd data length %zd error %@",
            [_request URL],[_request HTTPMethod],_statusCode,[_data length],_error];
}
@end
