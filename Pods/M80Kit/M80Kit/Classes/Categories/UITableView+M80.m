//
//  UITableView+M80.m
//  M80Kit
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import "UITableView+M80.h"

@implementation UITableView (M80)
- (void)m80HideExtraCell
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}
@end
