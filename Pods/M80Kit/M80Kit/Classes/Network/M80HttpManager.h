//
//  M80HttpManager.h
//  M80Kit
//
//  Created by amao on 1/8/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M80HttpOperation.h"

@interface M80HttpManager : NSOperation
+ (instancetype)sharedManager;

- (M80HttpOperation *)request:(NSURLRequest *)request
                      success:(M80HttpSuccess)success
                      failure:(M80HttpFailure)failure;

@end
