//
//  M80HttpServer.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80HttpServer.h"
#import "GCDWebUploader.h"
#import "M80PathManager.h"
#import "M80Util.h"

#define M80ServerPort   (1280)

@interface M80HttpServer ()
@property (nonatomic,strong)    GCDWebUploader  *uploader;
@end

@implementation M80HttpServer

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *dir = [[M80PathManager sharedManager] fileStoragePath];
        _uploader = [[GCDWebUploader alloc] initWithUploadDirectory:dir];
        _uploader.allowHiddenItems = YES;
        
    }
    return self;
}


- (NSString *)url
{
    return [[_uploader serverURL] absoluteString];
}

- (BOOL)isRunning
{
    return [_uploader isRunning];
}

- (BOOL)start
{
    return [_uploader startWithPort:1280
                        bonjourName:@"amaowifi"];
}


- (void)stop
{
    [_uploader stop];
}




@end
