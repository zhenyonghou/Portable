//
//  SFApplication.h
//
//  Created by hou zhenyong on 13-12-13.
//  Copyright (c) 2013年 zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBApplication : NSObject

+ (NSString*)applicationName;

+ (NSString*)applicationVersion;

+ (NSString*)applicationBuildVersion;

+ (NSString*)documentPath;

+ (NSString*)libraryPath;

+ (NSString*)cachesPath;

+ (BOOL)isEnableRemoteNotification;

+ (void)gotoSystemSetting;

/**
 跳转到应用在APP STORE上的下载页面
 */
+ (void)gotoItunesForDownloadApp:(NSString *)appId;

/**
 从APP STORE上获取应用版本信息
 */
+ (void)checkVersionWithAppId:(NSString*)appId complete:(void (^)(NSString *serverVersion))completeBlock;

@end

