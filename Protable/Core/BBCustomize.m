//
//  BACustomize.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBCustomize.h"

@implementation BBCustomize

+ (void)customize
{
    [[self class] customizeNavigationBar];
    [[self class] customizeStatusBar];
}

+ (void)customizeNavigationBar
{
    [[UINavigationBar appearance] setTintColor:SKIN_COLOR(@"color_navibar_title")];
    [UINavigationBar appearance].barTintColor = SKIN_COLOR(@"color_navibar_bg");
}

+ (void)customizeStatusBar
{
    // 必须在XXX-info.plist中设置：View controller-based status bar appearance 为 NO
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
