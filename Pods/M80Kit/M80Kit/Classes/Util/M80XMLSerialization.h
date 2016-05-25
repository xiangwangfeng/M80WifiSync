//
//  M80XMLSerialization.h
//  M80Kit
//
//  Created by amao on 9/22/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, M80XMLOptions)
{
    M80XMLOptionsProcessNamespaces      = 1 << 1,
    M80XMLOptionsReportNamespacePrefixs = 1 << 2,
    M80XMLOptionsResolveExternalEntities= 1 << 3,
};

@interface M80XMLSerialization : NSObject
+ (NSDictionary *)xmlObjectWithData:(NSData *)data
                            options:(M80XMLOptions)options
                              error:(NSError **)error;
@end
