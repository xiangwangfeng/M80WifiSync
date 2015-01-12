//
//  M80DirectoryViewController.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80DirectoryViewController.h"

@interface M80DirectoryViewController ()
@property (nonatomic,copy)    NSString  *dir;
@end

@implementation M80DirectoryViewController
- (instancetype)initWithDir:(NSString *)dir
{
    if (self = [super init])
    {
        _dir = [dir copy];
    }
    return self;
}


@end
