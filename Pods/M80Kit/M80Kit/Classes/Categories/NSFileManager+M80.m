//
//  NSFileManager+M80.m
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "NSFileManager+M80.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSData+M80.h"


@implementation NSFileManager (M80)
- (unsigned long long)m80FileSize:(NSString *)filepath
{
    unsigned long long fileSize = 0;
    if ([filepath length]  && [self fileExistsAtPath:filepath])
    {
        NSDictionary *attributes = [self attributesOfItemAtPath:filepath
                                                          error:nil];
        id item = [attributes objectForKey:NSFileSize];
        fileSize = [item isKindOfClass:[NSNumber class]] ? [item unsignedLongLongValue] : 0;
    }
    return fileSize;
}

- (NSString *)m80MimeTypeForFilepath:(NSString *)filepath
{
    NSString *extesion = [filepath pathExtension];
    return [self m80MimeTypeForFileExtension:extesion];
}

- (NSString *)m80MimeTypeForFileExtension:(NSString *)extension
{
    NSString *mimeType = nil;
    if ([extension length])
    {
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
        CFStringRef mimeTypeRef = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        CFRelease(UTI);
        if (!mimeTypeRef)
        {
            //某些机器无法解析某些后缀,加特别判断
            if ([extension isEqualToString:@"aac"])
            {
                mimeType = @"audio/aac";
            }
        }
        else
        {
            mimeType = CFBridgingRelease(mimeTypeRef);
        }
    }
    if (!mimeType)
    {
        mimeType = @"application/octet-stream";
    }
    return mimeType;
}

- (NSString *)m80MD5:(NSString *)filepath
{
    NSString *md5 = nil;
    if ([filepath length]  &&
        [[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        md5 = [data m80MD5];
    }
    return md5;
}

@end
