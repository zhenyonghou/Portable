//
//  SFApplication.h
//
//  Created by hou zhenyong on 13-12-13.
//  Copyright (c) 2013年 zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAApplication : NSObject

+ (NSString*)applicationName;

+ (NSString*)applicationVersion;

+ (NSString*)applicationBuildVersion;

+ (NSString*)documentPath;

+ (NSString*)libraryPath;

+ (NSString*)cachesPath;

+ (NSString *)crashFilePath;

@end

