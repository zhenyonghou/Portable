//
//  SDJsonFileProcessor.h
//  shuidi2
//
//  Created by houzhenyong on 14-5-15.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBJsonFileHelper : NSObject

+ (BOOL)writeData:(NSDictionary*)data toFile:(NSString*)filePath;

+ (void)readFromFilePath:(NSString*)filePath completeBlock:(void (^)(id jsonData, BOOL isSuccess))completeBlock;

@end
