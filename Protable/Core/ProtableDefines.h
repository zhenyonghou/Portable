//
//  ProtableDefines.h
//  PregnancyTracking
//
//  Created by hou zhenyong on 13-10-10.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_VERSION                 ([[[UIDevice currentDevice] systemVersion] floatValue])

// 一些常用相关尺寸

#define SCREEN_WIDTH                ([[UIScreen mainScreen]bounds].size.width)

#define SCREEN_HEIGHT               ([[UIScreen mainScreen]bounds].size.height)

#define PHONE_SCREEN_SIZE           (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

#define PHONE_STATUSBAR_HEIGHT      20

#define PHONE_NAVIGATIONBAR_HEIGHT  44

#define PHONE_KEYBOARD_HEIGHT       216

#define PHONE_TOOLBAR_HEIGHT        44

#define PHONE_TABBAR_HEIGHT         49

// 常用尺寸
#define TABLE_VIEW_CELL_HEIGHT      38
#define CONTENT_EDGE_LEFT_INSETS    8

// 去除selector警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

