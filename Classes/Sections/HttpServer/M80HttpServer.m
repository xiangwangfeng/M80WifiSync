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
        [_uploader startWithPort:1280
                     bonjourName:nil];
        
        [self savePasteboard];
        
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




#pragma mark - 通知处理
- (void)onEnterForeground:(NSNotification *)aNotification
{
    [self savePasteboard];
    
}

#pragma mark - 读取剪切板内容
- (void)savePasteboard
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *content = [board string];
    if (content != nil && ![self.lastClipContent isEqualToString:content])
    {
        self.lastClipContent = content;
        NSData *data = [[content stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *filepath = [[[M80PathManager sharedManager] fileStoragePath] stringByAppendingString:@"pasteboard.txt"];
        
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
}

- (void)setLastClipContent:(NSString *)lastClipContent
{
    if (lastClipContent)
    {
        [[NSUserDefaults standardUserDefaults] setObject:lastClipContent
                                                  forKey:@"clip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)lastClipContent
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"clip"];
}


@end
