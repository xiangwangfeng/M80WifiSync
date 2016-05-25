//
//  NSTimer+M80.m
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "NSTimer+M80.h"

@interface M80TimerTarget : NSObject
@property (nonatomic,copy)  M80TimerBlock   block;
- (void)onTimerFired:(NSTimer *)timer;
@end

@implementation M80TimerTarget

- (void)onTimerFired:(NSTimer *)timer
{
    if (_block)
    {
        _block();
    }
}

@end


@implementation NSTimer (M80)
+ (NSTimer *)m80TimerWithTimeInterval:(NSTimeInterval)seconds
                            fireBlock:(M80TimerBlock)block
                              repeats:(BOOL)repeats
{
    M80TimerTarget *target = [[M80TimerTarget alloc]init];
    target.block = block;
    
    return [NSTimer timerWithTimeInterval:seconds
                                   target:target
                                 selector:@selector(onTimerFired:)
                                 userInfo:nil
                                  repeats:repeats];
}

+ (NSTimer *)m80ScheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                     fireBlock:(M80TimerBlock)block
                                       repeats:(BOOL)repeats
{
    M80TimerTarget *target = [[M80TimerTarget alloc]init];
    target.block = block;
    
    return [NSTimer scheduledTimerWithTimeInterval:seconds
                                            target:target
                                          selector:@selector(onTimerFired:)
                                          userInfo:nil
                                           repeats:repeats];
}
@end
