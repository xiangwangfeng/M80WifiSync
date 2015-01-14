//
//  M80FileModel.m
//  M80WifiSync
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80FileModel.h"

@implementation M80FileModel
- (NSComparisonResult)compare:(M80FileModel *)model
{
    if (self.isDir == model.isDir)
    {
        return [self.filename localizedCompare:model.filename];
    }
    else
    {
        return self.isDir ? NSOrderedAscending : NSOrderedDescending;
    }
}

- (UIImage *)icon
{
    return nil;
}

@end