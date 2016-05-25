//
//  M80MulticastDelegate.h
//  M80Kit
//
//  Created by amao on 5/20/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80MulticastDelegate : NSObject
- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (NSUInteger)count;
- (NSUInteger)countForSelector:(SEL)aSelector;
- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector;
@end
