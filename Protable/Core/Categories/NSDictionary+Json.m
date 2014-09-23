//
//  NSDictionary+Json.m
//  Adult
//
//  Created by houzhenyong on 14-8-7.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (NSString*)toJsonString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return jsonString;
}

@end
