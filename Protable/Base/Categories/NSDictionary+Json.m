//
//  NSDictionary+Json.m
//  Adult
//
//  Created by houzhenyong on 14-8-7.

//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

+ (id)dictionaryWithJsonData:(NSData*)data
{
    if(!data)
    {
        NSLog(@"error: data is nil");
        return nil;
    }
    
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(ret && ![ret isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"error: data not a NSDictionary json");
        return nil;
    }
    
    return ret;
}

+ (id)dictionaryWithJsonString:(NSString *)string
{
    return [NSDictionary dictionaryWithJsonData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)toJsonData
{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
}

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
