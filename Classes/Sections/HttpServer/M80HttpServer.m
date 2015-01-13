//
//  M80HttpServer.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80HttpServer.h"
#import <UIKit/UIKit.h>
#import "GCDWebUploader.h"
#import "M80PathManager.h"
#import "M80Util.h"

#define M80ServerPort   (1280)

@interface M80HttpServer ()
@property (nonatomic,strong)    GCDWebUploader  *uploader;
@property (nonatomic,copy)      NSString *lastClipContent;
@end

@implementation M80HttpServer

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *dir = [[M80PathManager sharedManager] fileStoragePath];
        _uploader = [[GCDWebUploader alloc] initWithUploadDirectory:dir];
        _uploader.allowHiddenItems = YES;
        [_uploader start];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)url
{
    return [[_uploader serverURL] absoluteString];
}



- (void)appendString:(NSString *)content
{
    _lastClipContent = content;
    NSData *data = [[content stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filepath = [[[M80PathManager sharedManager] fileStoragePath] stringByAppendingString:@"pasteboard.html"];
    
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
    //复制剪贴板内容
     UIPasteboard *board = [UIPasteboard generalPasteboard];
     NSString *string = [board string];
     if (string != nil && ![_lastClipContent isEqualToString:string])
     {
         [self appendString:string];
     }
}


@end
