//
//  M80Timer.m
//  M80Kit
//
//  Created by amao on 6/11/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "M80Timer.h"
#import <mach/mach_time.h>

@implementation M80Timer
+ (CGFloat)timeCost:(dispatch_block_t)block
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}
@end
