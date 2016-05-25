//
//  UIColor+M80.m
//  M80Kit
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "UIColor+M80.h"


@interface M80ColorCache : NSObject
@property (nonatomic,strong)    NSCache     *colorCache;
@end

@implementation M80ColorCache

+ (instancetype)sharedCache
{
    static M80ColorCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[M80ColorCache alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _colorCache = [[NSCache alloc] init];
    }
    return self;
}

- (UIImage *)imageForColor:(UIColor *)color
{
    return color ? [_colorCache objectForKey:[color description]] : nil;
}


- (void)storeImage:(UIImage *)image
          forColor:(UIColor *)color
{
    if (image && color)
    {
        [_colorCache setObject:image
                        forKey:[color description]];
    }
}
@end

@implementation UIColor (M80)
- (UIImage *)m80ToImage
{
    UIImage *image = [[M80ColorCache sharedCache] imageForColor:self];
    if (image == nil)
    {
        CGFloat alphaChannel;
        [self getRed:NULL green:NULL blue:NULL alpha:&alphaChannel];
        BOOL opaqueImage = (alphaChannel == 1.0);
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContextWithOptions(rect.size, opaqueImage, [UIScreen mainScreen].scale);
        [self setFill];
        UIRectFill(rect);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[M80ColorCache sharedCache] storeImage:image
                                       forColor:self];
    }
    return image;
}


@end
