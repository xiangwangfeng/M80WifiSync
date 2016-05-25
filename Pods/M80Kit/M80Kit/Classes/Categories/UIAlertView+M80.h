//
//  UIAlertView+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^M80UIAlertViewBlock)(NSInteger index);

@interface UIAlertView (M80)
- (void)showWithCompletion:(M80UIAlertViewBlock)block;
@end
