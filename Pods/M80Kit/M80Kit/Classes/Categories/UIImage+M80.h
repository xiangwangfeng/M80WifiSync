//
//  UIImage+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//


@interface UIImage (M80)
//内缩放，一条变等于最长边，另外一条小于等于最长边
- (UIImage *)m80InternalScaled:(CGSize)newSize;

//采用外缩放：一遍等于请求长度，一遍大于等于请求长度
- (UIImage *)m80ExternalScaled:(CGSize)newSize;

- (UIImage *)m80ScaledWithPixels:(CGFloat)pixels;

- (BOOL)m80SaveAsJPEG:(NSString *)filepath
              quality:(CGFloat)quality;

- (UIImage *)m80FixOrientation;
@end
