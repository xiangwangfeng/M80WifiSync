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
#import "HttpServer.h"
#import "M80PathManager.h"

#define M80ServerPort   (1280)

@interface M80HttpServer ()
@property (nonatomic,strong)    HTTPServer  *server;
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
    }
    return self;
}

- (void)start
{
    [_server start:nil];
}

- (void)stop
{
    [_server stop];
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
@end
