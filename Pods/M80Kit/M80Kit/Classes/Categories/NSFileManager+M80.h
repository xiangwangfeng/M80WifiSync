//
//  NSFileManager+M80.h
//  M80Kit
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (M80)
- (unsigned long long)m80FileSize:(NSString *)filepath;

- (NSString *)m80MimeTypeForFilepath:(NSString *)filepath;

- (NSString *)m80MimeTypeForFileExtension:(NSString *)extension;

- (NSString *)m80MD5:(NSString *)filepath;

@end
