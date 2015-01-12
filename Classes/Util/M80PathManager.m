//
//  M80PathManager.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80PathManager.h"

@interface M80PathManager ()
@property (nonatomic,copy)  NSString    *webHostDir;
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

- (NSString *)webHostPath
{
    return _webHostDir;
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
    
    _webHostDir = [path stringByAppendingString:@"/Web/"];
    _fileStorageDir = [path stringByAppendingString:@"/Web/FileStorage/"];
    
    [self createDirIfNotExists:_webHostDir];
    [self createDirIfNotExists:_fileStorageDir];
    [self addSkipBackup:_webHostDir];
    
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
