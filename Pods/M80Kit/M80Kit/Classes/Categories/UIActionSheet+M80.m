//
//  UIActionSheet+M80.m
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "UIActionSheet+M80.h"
#import <objc/runtime.h>

static char kUIActionSheetBlockAddress;

@implementation UIActionSheet (M80)

- (void)showInView:(UIView *)view
 completionHandler:(M80UIActionSheetBlock)block
{
    self.delegate = (id<UIActionSheetDelegate>)self;
    objc_setAssociatedObject(self,&kUIActionSheetBlockAddress,block,OBJC_ASSOCIATION_COPY);
    [self showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    M80UIActionSheetBlock block = objc_getAssociatedObject(self, &kUIActionSheetBlockAddress);
    if (block)
    {
        block(buttonIndex);
        objc_setAssociatedObject(self,&kUIActionSheetBlockAddress,nil,OBJC_ASSOCIATION_COPY);
    }
}

@end
