//
//  NSURL+M80.m
//  M80Kit
//
//  Created by amao on 9/15/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "NSURL+M80.h"

@implementation NSURL (M80)
- (NSDictionary *)m80QueryComponents
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *query = [self query];
    if ([query length])
    {
        NSArray *components = [query componentsSeparatedByString:@"&"];
        for (NSString *component in components)
        {
            NSArray *keyAndValues = [component componentsSeparatedByString:@"?"];
            if ([keyAndValues count] == 2)
            {
                NSString *key = [keyAndValues firstObject];
                NSString *value = [keyAndValues lastObject];
                if ([key length] && [value length])
                {
                    [dict setObject:value
                             forKey:key];
                }
            }
        }
    }
    return dict;
}
@end
