//
//  M80XMLSerialization.m
//  M80Kit
//
//  Created by amao on 9/22/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "M80XMLSerialization.h"

@interface M80XMLReader : NSObject<NSXMLParserDelegate>
@property (nonatomic,strong)    NSMutableArray *stacks;
@property (nonatomic,strong)    NSError *error;
@end

@implementation M80XMLReader

- (NSDictionary *)parse:(NSData *)data
                options:(M80XMLOptions)options
                  error:(NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:(options & M80XMLOptionsProcessNamespaces)];
    [parser setShouldReportNamespacePrefixes:(options & M80XMLOptionsReportNamespacePrefixs)];
    [parser setShouldResolveExternalEntities:(options & M80XMLOptionsResolveExternalEntities)];
    
    //初始化堆栈
    _stacks = [NSMutableArray array];
    [_stacks addObject:[NSMutableDictionary dictionary]];
    
    NSDictionary *result = nil;
    BOOL success = [parser parse];
    if (success)
    {
        result = [_stacks firstObject];
    }
    else
    {
        if (error)
        {
            *error = _error;
        }
    }
    return result;
}

#pragma mark - ParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *parentDict = [_stacks lastObject];
    NSMutableDictionary *childDict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    
    id existedValue = [parentDict objectForKey:elementName];
    if (existedValue)
    {
        if ([existedValue isKindOfClass:[NSMutableArray class]])
        {
            [(NSMutableArray *)existedValue addObject:parentDict];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:existedValue];
            [array addObject:childDict];
            [parentDict setObject:array
                           forKey:elementName];
        }
    }
    else
    {
        [parentDict setObject:childDict
                       forKey:elementName];
    }
    [_stacks addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [_stacks removeLastObject];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.error = parseError;
}

@end

@implementation M80XMLSerialization
+ (NSDictionary *)xmlObjectWithData:(NSData *)data
                            options:(M80XMLOptions)options
                              error:(NSError **)error
{
    M80XMLReader *reader = [[M80XMLReader alloc]init];
    return [reader parse:data
                 options:options
                   error:error];
}
@end
