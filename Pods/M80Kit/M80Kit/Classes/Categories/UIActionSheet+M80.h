//
//  UIActionSheet+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^M80UIActionSheetBlock)(NSInteger);

@interface UIActionSheet (M80)
- (void)showInView:(UIView *)view
 completionHandler:(M80UIActionSheetBlock)block;
@end
