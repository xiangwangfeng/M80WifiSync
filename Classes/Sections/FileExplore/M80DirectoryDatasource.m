//
//  M80DirectoryDatasource.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80DirectoryDatasource.h"
#import "M80Util.h"




@interface M80DirectoryDatasource ()
@property (nonatomic,strong)    NSMutableArray  *subFiles;
@end

@implementation M80DirectoryDatasource
+ (instancetype)datasource:(NSString *)dir
{
    M80DirectoryDatasource *instance = [[M80DirectoryDatasource alloc] initWithDir:dir];
    [instance refresh];
    return instance;
}

- (instancetype)initWithDir:(NSString *)dir
{
    if (self = [super init])
    {
        _dir = dir;
    }
    return self;
}

- (void)refresh
{
    _subFiles = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:_dir isDirectory:&isDir] &&
        isDir)
    {
        
        NSArray *subPaths = [fileManager contentsOfDirectoryAtPath:_dir
                                                             error:nil];
        for (NSString *filename in subPaths)
        {
            NSString *filepath = [_dir stringByAppendingString:filename];
            M80FileModel *model = [[M80FileModel alloc] init];
            model.filepath = filepath;
            model.filename = [filepath lastPathComponent];
            
            
            BOOL pathIsDir = NO;
            [fileManager fileExistsAtPath:filepath
                              isDirectory:&pathIsDir];
            model.isDir    = pathIsDir;
            
            [_subFiles addObject:model];
        }
    }
    [_subFiles sortUsingSelector:@selector(compare:)];
    
}

- (NSArray *)files
{
    return _subFiles;
}

#pragma mark - 移除文件
- (BOOL)removeFile:(NSString *)filepath
{
    BOOL success = NO;
    NSInteger index = -1;
    for (NSInteger i = 0; i < [_subFiles count]; i++)
    {
        M80FileModel *model = [_subFiles objectAtIndex:i];
        if ([model.filepath isEqualToString:filepath])
        {
            index = i;
            break;
        }
    }
    if (index != -1)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
        {
            if ([[NSFileManager defaultManager] removeItemAtPath:filepath
                                                           error:nil])
            {
                [_subFiles removeObjectAtIndex:index];
                success = YES;
            }
        }
    }
    return success;
}


#pragma mark - 添加目录
- (BOOL)createDir:(NSString *)dirName
{
    NSString *createdDir = nil;
    if ([dirName length])
    {
        NSString *filepath = [_dir stringByAppendingString:dirName];
        NSInteger index = 0;
        do
        {
            NSString *dir = index != 0 ? [filepath stringByAppendingFormat:@"%zd",index] : filepath;
            BOOL isDir = NO;
            if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] ||
                !isDir)
            {
                if ([[NSFileManager defaultManager] createDirectoryAtPath:dir
                                              withIntermediateDirectories:NO
                                                               attributes:nil
                                                                    error:nil])
                {
                    createdDir = dir;
                }
                break;
            }
            index++;
        }while (YES);
    }
    if (createdDir)
    {
        M80FileModel *model = [[M80FileModel alloc] init];
        model.filename = [createdDir lastPathComponent];
        model.filepath = createdDir;
        model.isDir = YES;
        [self addFileModelAndSort:model];
    }
    return createdDir != nil;
}

- (void)addFileModelAndSort:(M80FileModel *)model
{
    BOOL add = NO;
    for (NSInteger i = 0; i < [_subFiles count]; i++)
    {
        M80FileModel *fileModel = [_subFiles objectAtIndex:i];
        if ([fileModel compare:model] == NSOrderedDescending)
        {
            [_subFiles insertObject:model
                            atIndex:i];
            add = YES;
            break;
        }
    }
    if (!add)
    {
        [_subFiles addObject:model];
    }
}

@end
