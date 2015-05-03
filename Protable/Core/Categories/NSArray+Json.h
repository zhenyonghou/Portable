//
//  NSArray+Json.h
//
//  Created by houzhenyong on 14-9-26.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Json)

+ (id)arrayWithJsonString:(NSString*)string;

+ (id)arrayWithJsonData:(NSData *)data;

- (NSString *)toJsonString;

- (NSData *)toJsonData;

@end
