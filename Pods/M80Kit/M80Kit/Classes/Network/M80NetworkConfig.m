//
//  M80NetworkConfig.m
//  M80Kit
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "M80NetworkConfig.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>



@implementation M80NetworkConfig
+ (instancetype)currentConfig
{
    static M80NetworkConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80NetworkConfig alloc] init];
    });
    return instance;
}

- (NSString *)localIP
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


- (NSString *)currentSSID
{
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs)
    {
        NSDictionary *infos = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if ([infos objectForKey:@"SSID"])
        {
            ssid = [infos objectForKey:@"SSID"];
            break;
        }
    }
    return ssid;
}
@end
