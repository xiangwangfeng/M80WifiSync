//
//  M80HttpOperation.h
//  M80Kit
//
//  Created by amao on 1/8/15.
//  Copyright (c) 2015 amao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger
{
    M80HttpCodeInvalidRequest   = 1,
    M80HttpCodeInvalidResponse  = 2,
} M80HttpCode;

@class M80HttpOperation;

typedef void(^M80HttpSuccess)(M80HttpOperation *operation,NSData *data);
typedef void(^M80HttpFailure)(M80HttpOperation *operation,NSError *error);


@interface M80HttpOperation : NSOperation
@property (nonatomic,strong)    NSURLRequest        *request;
@property (nonatomic,copy)      M80HttpSuccess      success;
@property (nonatomic,copy)      M80HttpFailure      failure;

@property (nonatomic,strong,readonly)   NSHTTPURLResponse   *response;
@property (nonatomic,strong,readonly)   NSData              *responseData;
@property (nonatomic,assign,readonly)   NSInteger           statusCode;
@property (nonatomic,strong,readonly)   NSError             *error;
@end
