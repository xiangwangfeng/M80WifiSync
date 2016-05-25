//
//  M80Timer.h
//  M80Kit
//
//  Created by amao on 6/11/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80Timer : NSObject
+ (CGFloat)timeCost:(dispatch_block_t)block;
@end
