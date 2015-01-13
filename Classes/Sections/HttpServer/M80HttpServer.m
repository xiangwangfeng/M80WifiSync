//
//  M80HttpServer.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80HttpServer.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>
#import "HttpServer.h"
#import "M80PathManager.h"

#define M80ServerPort   (1280)

@interface M80HttpServer ()
@property (nonatomic,strong)    HTTPServer  *server;
@property (nonatomic,copy)      NSString *lastClipContent;
@end

@implementation M80HttpServer
+ (instancetype)sharedServer
{
    static M80HttpServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80HttpServer alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _server = [[HTTPServer alloc] init];
        [_server setPort:M80ServerPort];
        [_server setDocumentRoot:[[M80PathManager sharedManager] webHostPath]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start
{
    [_server start:nil];
    
    //复制剪贴板内容
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *string = [board string];
    if (string != nil && ![_lastClipContent isEqualToString:string])
    {
        [self appendString:string];
    }
}


- (NSString *)url
{
    return [NSString stringWithFormat:@"http://%@:%zd",[self currentIP],M80ServerPort];
}

- (NSString *)currentIP
{
    NSString *address = @"127.0.0.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if( temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSString *ifaName = [NSString stringWithUTF8String:temp_addr->ifa_name];
                if ([ifaName hasPrefix:@"en"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

- (void)appendString:(NSString *)content
{
    _lastClipContent = content;
    NSData *data = [[content stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filepath = [[[M80PathManager sharedManager] webHostPath] stringByAppendingString:@"pasteboard.html"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filepath];
        if (handle)
        {
            [handle seekToEndOfFile];
            [handle writeData:data];
            [handle closeFile];
        }
    }
    else
    {
        [data writeToFile:filepath atomically:YES];
    }

}

#pragma mark - 通知处理
- (void)onEnterForeground:(NSNotification *)aNotification
{
    [self start];
}

- (void)onEnterBackground:(NSNotification *)aNotification
{
    [_server stop];
}
@end
