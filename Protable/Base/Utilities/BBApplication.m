//
//  BBApplication.m
//
//  Created by hou zhenyong on 13-12-13.
//  Copyright (c) 2013年 zhenyonghou. All rights reserved.
//

#import "BBApplication.H"

@implementation BBApplication

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

+ (BOOL)isEnableRemoteNotification
{
    BOOL isEnable = YES;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIUserNotificationSettings *settings = [UIApplication sharedApplication].currentUserNotificationSettings;
        if (settings.types == UIUserNotificationTypeNone) {
            isEnable = NO;
        }
    } else {
        if (UIRemoteNotificationTypeNone == [UIApplication sharedApplication].enabledRemoteNotificationTypes) {
            isEnable = NO;
        }
    }
    
    return isEnable;
}

+ (void)gotoSystemSetting {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"]];       // 设置URL Types :prefs
    }
}


+ (void)gotoItunesForDownloadApp:(NSString *)appId
{
    NSString *downloadUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", appId];
    @try {
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:downloadUrl]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+ (void)checkVersionWithAppId:(NSString*)appId complete:(void (^)(NSString *serverVersion))completeBlock {
    NSString *appURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:appURL]];
    [request setHTTPMethod:@"POST"];

    //将请求的url数据放到NSData对象中
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error)
     {
         if (!data || !resp) {      // 无网环境
             completeBlock(nil);
         }
         
         NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         //NSLog(@"VersionDic:%@", dic);
         
         NSArray *infoArray = [dic objectForKey:@"results"];
         if ([infoArray count]) {
             NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
             NSString *serverVersion = [releaseInfo objectForKey:@"version"];
             completeBlock(serverVersion);
         } else {
             completeBlock(nil);
         }
     }
     ];
}

@end
