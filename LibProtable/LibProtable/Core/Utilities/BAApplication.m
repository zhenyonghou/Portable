//
//  SFApplication.m
//
//  Created by hou zhenyong on 13-12-13.
//  Copyright (c) 2013年 zhenyonghou. All rights reserved.
//

#import "BAApplication.H"

#define kCrashLogPath       @"crashlog"

@implementation BAApplication

+ (NSString*)applicationName
{
    NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+ (NSString*)applicationVersion
{
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (NSString*)applicationBuildVersion
{
    NSString* appBuildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appBuildVersion;
}

//  返回Document目录的路径
+ (NSString *)documentPath
{
    NSArray  *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    return path;
}

//  返回Library目录的路径
+ (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//  返回Caches目录的路径
+ (NSString *)cachesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)crashFilePath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[BAApplication documentPath], kCrashLogPath];
    return filePath;
}


@end
