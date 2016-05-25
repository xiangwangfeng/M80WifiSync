//
//  M80FolderMonitor.h
//  M80Kit
//
//  Created by amao on 2/28/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80FolderMonitor : NSObject
+ (instancetype)monitor:(NSURL *)dirURL
                  block:(dispatch_block_t)block;

- (void)start;
- (void)stop;

@end
