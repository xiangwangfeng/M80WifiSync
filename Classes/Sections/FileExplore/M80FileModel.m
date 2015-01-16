//
//  M80FileModel.m
//  M80WifiSync
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80FileModel.h"

@interface M80FileIconManager : NSObject
@property (nonatomic,strong)    NSDictionary *icons;
@end

@implementation M80FileIconManager
+ (instancetype)sharedManager
{
    static M80FileIconManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80FileIconManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _icons = @{@"pdf"   : @"ic_pdf",
                   @"txt"   : @"ic_txt",
                   @"doc"   : @"ic_word",
                   @"docx"  : @"ic_word",
                   @"xls"   : @"ic_excel",
                   @"xlsx"  : @"ic_excel",
                   @"ppt"   : @"ic_ppt",
                   @"pptx"  : @"ic_ppt",
                   @"html"  : @"ic_html",
                   @"rar"   : @"ic_rar",
                   @"zip"   : @"ic_zip",
                   @"mp4"   : @"ic_mpeg",
                   @"mp3"   : @"ic_mp3",
                   @"png"   : @"ic_png",
                   @"jpg"   : @"ic_jpg",
                   @"jpeg"  : @"ic_jpg",
                   @"gif"   : @"ic_gif",
                   @"mov"   : @"ic_mov",
                   @"psd"   : @"ic_psd",
                   @"3gs"   : @"ic_mpeg",
                   @"m4v"   : @"ic_mpeg",
                   };
    }
    return self;
}

- (UIImage *)icon:(NSString *)filepath
{
    UIImage *image = nil;
    NSString *ext = [[filepath pathExtension] lowercaseString];
    if (ext)
    {
        NSString *imageName = [_icons objectForKey:ext];
        if (imageName)
        {
            image = [UIImage imageNamed:imageName];
        }
    }
    return image ? : [UIImage imageNamed:@"ic_unknown"];
}

@end

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
    return _isDir ? [UIImage imageNamed:@"ic_folder"] :
    [[M80FileIconManager sharedManager] icon:_filepath];
}

@end