//
//  M80NetworkConfig.h
//  M80Kit
//
//  Created by amao on 1/14/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M80NetworkConfig : NSObject
+ (instancetype)currentConfig;
- (NSString *)localIP;
- (NSString *)currentSSID;
@end
