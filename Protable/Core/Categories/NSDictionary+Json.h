//
//  NSDictionary+Json.h
//  Adult
//
//  Created by houzhenyong on 14-8-7.

//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

+ (id)dictionaryWithJsonData:(NSData *)data;
+ (id)dictionaryWithJsonString:(NSString *)string;

- (NSData *)toJsonData;
- (NSString *)toJsonString;

@end
