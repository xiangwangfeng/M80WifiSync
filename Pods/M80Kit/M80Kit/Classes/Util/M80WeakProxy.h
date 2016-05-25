//
//  M80WeakProxy.h
//  M80Kit
//
//  Created by amao on 6/20/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M80WeakProxy : NSObject
+ (instancetype)weakProxyForObject:(id)object;
@end
