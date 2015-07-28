//
//  NSArray+Json.m
//  test
//
//  Created by houzhenyong on 14-9-26.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "NSArray+Json.h"

@implementation NSArray (Json)

+ (id)arrayWithJsonData:(NSData*)data
{
    if(!data)
    {
        NSLog(@"error: data is nil");
        return nil;
    }
    
    NSArray *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(ret && ![ret isKindOfClass:[NSArray class]])
    {
        NSLog(@"error: data not a NSArray json");
        return nil;
    }
    
    return ret;
}

+ (id)arrayWithJsonString:(NSString *)string
{
    return [NSArray arrayWithJsonData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)toJsonData
{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
}

- (NSString *)toJsonString
{
    return [[NSString alloc] initWithData:[self toJsonData] encoding:NSUTF8StringEncoding];
}

@end
