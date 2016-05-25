//
//  NSString+M80.m
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "NSString+M80.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (M80)
- (NSString *)m80MD5
{
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

- (NSString *)m80Trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)m80StringByURLEncoding
{
    static NSString * const kM80LegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
    
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge  CFStringRef)self,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)kM80LegalCharactersToBeEscaped,
                                                                                 kCFStringEncodingUTF8);
}

- (NSData *)m80HexToBinary
{
#ifdef DEBUG
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound) {
        return nil;
    }
#endif
    
    NSMutableData *data = [NSMutableData data];
    const char *src = [self UTF8String];
    unsigned long length = strlen(src);
    char byteChars[3] = {0};
    
    for (unsigned long i = 0; i + 1 < length; i +=2)
    {
        byteChars[0] = src[i];
        byteChars[1] = src[i+1];
        unsigned long wholeBytes = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeBytes length:1];
    }
    return data;
}

- (NSUInteger)m80GBKBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}
@end
