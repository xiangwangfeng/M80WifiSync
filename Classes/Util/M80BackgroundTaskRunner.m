//
//  M80BackgroundTaskRunner.m
//  NIMLib
//
//  Created by amao on 10/23/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "M80BackgroundTaskRunner.h"

@interface M80BackgroundTaskRunner ()
@property (nonatomic,assign)    UIBackgroundTaskIdentifier  backgroundTaskID;
@end

@implementation M80BackgroundTaskRunner
- (instancetype)init
{
    if (self = [super init])
    {
        _backgroundTaskID = UIBackgroundTaskInvalid;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didEnterBackground:(NSNotification *)aNotification
{
    _backgroundTaskID =  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (_backgroundTaskID != UIBackgroundTaskInvalid)
        {
            [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskID];
            _backgroundTaskID = UIBackgroundTaskInvalid;
        }
    }];
}

- (void)willEnterForeground:(NSNotification *)aNotification
{
    if (_backgroundTaskID != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskID];
        _backgroundTaskID = UIBackgroundTaskInvalid;
    }
}
@end
