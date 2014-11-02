//
//  AppDelegate.m
//  Colleague
//
//  Created by houzhenyong on 14-5-10.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "AppDelegate.h"
#import "Protable.h"
#import "AppStartup.h"
#import "AppNavigator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [AppStartup settingForAppStartup];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    NSLog(@"openURL:%@", url);
//    if ([url.absoluteString hasPrefix:@"wb"]) {
//        return [[COWeiboService sharedInstance] handleOpenURL:url];
//    }
//    else if ([url.absoluteString hasPrefix:@"tencent"]){
//        return [[COQQService sharedInstance] handleOpenURL:url];
//    }
//    else if ([url.absoluteString hasSuffix:@"wechat"]) {
//        return [[COWeChatService sharedInstance] handleOpenURL:url];
//    }
//    else {
//        return NO;
//    }
//}

// for APNS (Apple Push Notification Service)

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
//    if([token length] > 1) {
//        token = [token substringWithRange:NSMakeRange(1, [token length] - 2)];
//    }
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    DDLogInfo(@"received deviceToken=%@", token);
//    [BAUserConfig sharedInstance].deviceToken = token;
//    [[BAUserConfig sharedInstance] saveImmediately];
//
//    // login
//    [[AppNavigator navigator] startLogin];
//}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    DDLogInfo(@"regtister fail: %@", error);
//    [[AppNavigator navigator] startLogin];
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    DDLogInfo(@"userInfo: %@", userInfo);
//    
//    if (![[COUserInformation sharedInstance] hasLogin]) {
//        return;
//    }
//    
//    [[ADPushNotificationCenter sharedInstance] handlerNotify:userInfo];
//    
//    // 直接设置成0无效
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}



@end
