//
//  NSString+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (M80)
- (NSString *)m80MD5;

- (NSString *)m80Trim;

- (NSString *)m80StringByURLEncoding;

- (NSData *)m80HexToBinary;

- (NSUInteger)m80GBKBytesLength;
@end
