//
//  M80PathManager.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80PathManager.h"

@interface M80PathManager ()
@property (nonatomic,copy)  NSString    *fileStorageDir;
@end

@implementation M80PathManager
+ (instancetype)sharedManager
{
    static M80PathManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80PathManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}


- (NSString *)fileStoragePath
{
    return _fileStorageDir;
}

#pragma mark - misc
- (void)setup
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    
    _fileStorageDir = [path stringByAppendingString:@"/FileStorage/"];
    
    [self createDirIfNotExists:_fileStorageDir];
    [self addSkipBackup:_fileStorageDir];
    
    NSArray *folders = @[NSLocalizedString(@"文档", nil),
                         NSLocalizedString(@"图片", nil),
                         NSLocalizedString(@"视频", nil),
                         NSLocalizedString(@"表情", nil)];
    for (NSString *name in folders)
    {
        NSString *dir = [_fileStorageDir stringByAppendingPathComponent:name];
        [self createDirIfNotExists:dir];
    }
}

- (void)addSkipBackup:(NSString *)filepath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSURL *url = [NSURL fileURLWithPath:filepath];
        if (![url setResourceValue:@(YES)
                            forKey:NSURLIsExcludedFromBackupKey
                             error:nil])
        {
            
        }
    }
}

- (void)createDirIfNotExists:(NSString *)dirPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}
@end
