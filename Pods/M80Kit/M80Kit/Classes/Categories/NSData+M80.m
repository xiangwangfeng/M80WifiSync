//
//  NSData+M80.m
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "NSData+M80.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (M80)
- (NSString *)m80BinaryToHex
{
    NSMutableString *hexString = [[NSMutableString alloc]init];
    unsigned char *bytes = (unsigned char *)[self bytes];
    for(NSUInteger i = 0; i < [self length]; i++)
    {
        [hexString appendFormat:@"%02x",bytes[i]];
    }
    return [hexString copy];
}

- (NSString *)m80MD5
{
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}
@end
