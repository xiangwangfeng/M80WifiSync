//
//  NSTimer+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef dispatch_block_t M80TimerBlock;

@interface NSTimer (M80)
+ (NSTimer *)m80TimerWithTimeInterval:(NSTimeInterval)seconds
                            fireBlock:(M80TimerBlock)block
                              repeats:(BOOL)repeats;

+ (NSTimer *)m80ScheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                     fireBlock:(M80TimerBlock)block
                                       repeats:(BOOL)repeats;
@end
