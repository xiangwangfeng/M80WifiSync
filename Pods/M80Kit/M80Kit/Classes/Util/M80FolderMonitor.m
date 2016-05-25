//
//  M80FolderMonitor.m
//  M80Kit
//
//  Created by amao on 2/28/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "M80FolderMonitor.h"


dispatch_queue_t GetFileMonitorQueue()
{
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.xiangwangfeng.file.monitor.queue", 0);
    });
    return queue;
}

@interface M80FolderMonitor ()
{
    int    _fileDescriptor;
    dispatch_source_t _source;
}
@property (nonatomic,strong)    NSURL               *url;
@property (nonatomic,copy)      dispatch_block_t    block;

@end


@implementation M80FolderMonitor

+ (instancetype)monitor:(NSURL *)dirURL
                  block:(dispatch_block_t)block
{
    dispatch_block_t callback = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
            {
                block();
            }
        });
    };
    
    M80FolderMonitor *instance = [[M80FolderMonitor alloc] init];
    instance.url = dirURL;
    instance.block  = callback;

    return instance;
}

- (void)dealloc
{
    [self stop];
}

- (void)start
{
    @synchronized(self)
    {
        _fileDescriptor = open([_url.path fileSystemRepresentation], O_EVTONLY);
        
        if (!_fileDescriptor) {
            return;
        }
        
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, _fileDescriptor, DISPATCH_VNODE_WRITE, GetFileMonitorQueue());
        
        dispatch_source_set_event_handler(_source, _block);
        dispatch_source_set_cancel_handler(_source, ^{
            close(_fileDescriptor);
        });
        dispatch_resume(_source);
    }
}

- (void)stop
{
    @synchronized(self)
    {
        if (!_source)
        {
            return;
        }
        dispatch_source_cancel(_source);
        _source = nil;
    }

}
@end
