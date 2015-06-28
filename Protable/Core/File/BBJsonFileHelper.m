//
//  SDJsonFileProcessor.m
//  shuidi2
//
//  Created by houzhenyong on 14-5-15.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import "BBJsonFileHelper.h"

@implementation BBJsonFileHelper

+ (BOOL)writeData:(NSDictionary*)data toFile:(NSString*)filePath
{
    BOOL isSuccess = NO;
    NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    [outputStream open];
    if (outputStream) {
        NSInteger bytes = [NSJSONSerialization writeJSONObject:data toStream:outputStream options:NSJSONWritingPrettyPrinted error:nil];
        if (bytes > 0) {
            isSuccess = YES;
        } else {
            NSAssert(NO, @"%s", __FUNCTION__);
        }
    }
    [outputStream close];
    return isSuccess;
}

+ (void)readFromFilePath:(NSString*)filePath completeBlock:(void (^)(id jsonData, BOOL isSuccess))completeBlock
{
    id container = nil;
    BOOL isSuccess = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSInputStream* inputStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        if (inputStream) {
            NSError *error;
            [inputStream open];
            container = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingMutableContainers error:&error];
            [inputStream close];

            if (!error) {
                isSuccess = YES;
            }
        }
    }
    completeBlock(container, isSuccess);
}

@end
