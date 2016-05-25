//
//  M80Observer.m
//  M80Kit
//
//  Created by amao on 5/26/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "M80Observer.h"


typedef NS_ENUM(NSUInteger, M80ObserveType) {
    M80ObserveTypeNone,
    M80ObserveTypeOldAndNew,
    M80ObserveTypeChange,
};
@interface M80Observer ()
@property (nonatomic,weak)      id              observeObject;
@property (nonatomic,strong)    NSString        *keyPath;
@property (nonatomic,copy)      id              block;
@property (nonatomic,assign)    M80ObserveType  type;

@end

@implementation M80Observer

- (void)dealloc
{
    _block = nil;
    [_observeObject removeObserver:self
                        forKeyPath:_keyPath];
    _observeObject = nil;
}


- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                         block:(id)block
                       options:(NSKeyValueObservingOptions)options
                          type:(M80ObserveType)type
{
    if (self = [super init])
    {
        _observeObject  = object;
        _keyPath        = keyPath;
        _block          = [block copy];
        _type           = type;
        
        [object addObserver:self
                 forKeyPath:keyPath
                    options:options
                    context:NULL];
    }
    return self;
}

+ (instancetype)observer:(id)object
                 keyPath:(NSString *)keyPath
                   block:(M80ObserverBlock)block
{
    return [[M80Observer alloc]initWithObject:object
                                      keyPath:keyPath
                                        block:block
                                      options:0
                                         type:M80ObserveTypeNone];
}

+ (instancetype)observer:(id)object
                 keyPath:(NSString *)keyPath
          oldAndNewBlock:(M80ObserverBlockWithOldAndNew)block
{
    return [[M80Observer alloc]initWithObject:object
                                      keyPath:keyPath
                                        block:block
                                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                         type:M80ObserveTypeOldAndNew];
}

+ (instancetype)observer:(id)object keyPath:(NSString *)keyPath
                 options:(NSKeyValueObservingOptions)options
             changeBlock:(M80ObserverBlockWithChangeDictionary)block
{
    return [[M80Observer alloc]initWithObject:object
                                      keyPath:keyPath
                                        block:block
                                      options:options
                                         type:M80ObserveTypeChange];

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    switch (_type)
    {
        case M80ObserveTypeNone:
            if (_block)
            {
                ((M80ObserverBlock)_block)();
            }
            break;
        case M80ObserveTypeOldAndNew:
            if (_block)
            {
                ((M80ObserverBlockWithOldAndNew)_block)(change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
            }
            break;
        case M80ObserveTypeChange:
            if (_block)
            {
                ((M80ObserverBlockWithChangeDictionary)_block)(change);
            }
            break;
        default:
            break;
    }
}

@end
