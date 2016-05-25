//
//  M80Observer.h
//  M80Kit
//
//  Created by amao on 5/26/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^M80ObserverBlock)(void);
typedef void(^M80ObserverBlockWithOldAndNew)(id oldValue, id newValue);
typedef void(^M80ObserverBlockWithChangeDictionary)(NSDictionary *change);

@interface M80Observer : NSObject

+ (instancetype)observer:(id)object
                 keyPath:(NSString *)keyPath
                   block:(M80ObserverBlock)block;

+ (instancetype)observer:(id)object
                 keyPath:(NSString *)keyPath
          oldAndNewBlock:(M80ObserverBlockWithOldAndNew)block;

+ (instancetype)observer:(id)object
                 keyPath:(NSString *)keyPath
                 options:(NSKeyValueObservingOptions)options
             changeBlock:(M80ObserverBlockWithChangeDictionary)block;

@end
