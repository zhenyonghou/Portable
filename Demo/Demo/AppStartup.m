//
//  AppStartup.m
//  Colleague
//
//  Created by houzhenyong on 14-5-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "AppStartup.h"
//#import "COApplicationService.h"
#import "UIViewController+BAAdditions.h"
//#import "BATabBarController.h"
#import "AppNavigator.h"

@implementation AppStartup

+ (void)settingForAppStartup
{
    // Step0 设置崩溃监控
//    [BAUncaughtExceptionHandler checkAndUploadLocalCrashLog:^(NSString *crashInfo) {
//        ADPostCrashSession *session = [[ADPostCrashSession alloc] init];
//        [session postWithCrashInfo:crashInfo success:^{
//            [MobClick event:@"post_crash" label:@"success"];
//        } failure:^(NSError *error) {
//            [MobClick event:@"post_crash" label:@"error"];;
//        }];
//    }];

    [[BAUserConfig sharedInstance] registerDefaults];
    
    // Step1 设置皮肤
    NSString *currentSkinName = [BAUserConfig sharedInstance].currentSkinName;
    [[BASkinResourceManager sharedInstance] changeSkinWithName:currentSkinName];
    
    // Step2 设置 bar
    [BBCustomize customize];
    
    [[AppNavigator navigator] openTabBarControllers];
    
    // Step3 Log
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
//    [DDTTYLogger sharedInstance].colorsEnabled = YES;
//    
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
//    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//
//    [DDLog addLogger:fileLogger];
//    DDLogInfo(@"%s", __FUNCTION__);
    
    // Step4 设置APNS
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
//                                                                           | UIRemoteNotificationTypeSound
//                                                                           | UIRemoteNotificationTypeAlert)];
//    
//    [[COApplicationService sharedInstance] registService];
}

@end
