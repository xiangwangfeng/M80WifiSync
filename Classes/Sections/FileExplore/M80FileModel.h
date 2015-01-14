//
//  M80FileModel.h
//  M80WifiSync
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//



@interface M80FileModel : NSObject
@property (nonatomic,copy)         NSString    *filename;
@property (nonatomic,assign)       BOOL        isDir;
@property (nonatomic,copy)         NSString    *filepath;

- (NSComparisonResult)compare:(M80FileModel *)model;
- (UIImage *)icon;
@end