//
//  BACustomize.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BACustomize.h"

@implementation BACustomize

+ (void)customize
{
    [[self class] customizeNavigationBar];
    
    [[self class] customizeButtonItem];
    
    [[self class] customizeBackButton];
    
    [[self class] customizeStatusBar];
    
    [[self class] customizeTabBar];
    
    [[self class] customizeToolBar];
}

+ (void)onSkinChanged
{
    [[self class] customizeButtonItem];
    [[self class] customizeBackButton];
}

+ (void)customizeNavigationBar
{
    if (IOS_VERSION >= 7.0) {
        // 改变左右按钮颜色
        [[UINavigationBar appearance] setTintColor:SKIN_COLOR(@"color_navibar_title")];
        
        [UINavigationBar appearance].barTintColor = SKIN_COLOR(@"color_navibar_bg");
//        UIImage *naviBarImage = [UIImage resizeFromCenterWithImage:SKIN_IMAGE(@"navigationBarBkgnd_ios7")];
//        [[UINavigationBar appearance] setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    } else {
        // 设置tintColor只能设置颜色，不能扁平，所以得设置图片
        UIImage *naviBarImage = [UIImage resizeFromCenterWithImage:SKIN_IMAGE(@"navigationBarBkgnd")];
        [[UINavigationBar appearance] setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];;
    }
}

// 导航栏的返回按钮
+ (void)customizeBackButton
{
    if (IOS_VERSION < 7.0) {
        UIImage *naviBackImage = [SKIN_IMAGE(@"BackArrowWhite") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:naviBackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *dic = @{UITextAttributeFont: [UIFont systemFontOfSize:18], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
}

+ (void)customizeToolBar
{
    if (IOS_VERSION < 7.0) {
        [[UIToolbar appearance] setBackgroundImage:SKIN_IMAGE(@"ToolBarBkgnd") forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setShadowImage:SKIN_IMAGE(@"transparent") forToolbarPosition:UIBarPositionAny];
    }
}

+ (void)customizeTabBar
{
    if (IOS_VERSION >= 7.0) {
        [UITabBar appearance].tintColor = SKIN_COLOR(@"color_tabbar_tint");
        [UITabBar appearance].barTintColor = SKIN_COLOR(@"color_tabbar_bg");
        
//        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_tabbar_bg")]];
//        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:SKIN_COLOR(@"color_tabbar_bg")]];
    } else {
        // 设置背景
        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_tabbar_bg")]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:SKIN_COLOR(@"color_tabbar_bg")]];
        
        [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
        
        NSDictionary* normalAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11],
                                           UITextAttributeTextColor : SKIN_COLOR(@"font_color_c"),
                                           NSKernAttributeName : @(1.2)};
        [[UITabBarItem appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        
        NSDictionary* selectedAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11],
                                             UITextAttributeTextColor : SKIN_COLOR(@"color_segment_text_normal"),
                                             NSKernAttributeName : @(1.2)};
        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    }
}

+ (void)customizeStatusBar
{
    // 必须在XXX-info.plist中设置：View controller-based status bar appearance 为 NO
    if (IOS_VERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
}

+ (void)customizeButtonItem
{
    // 去掉iOS6中讨厌的 border
    if (IOS_VERSION < 7.0) {
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
    }
}



@end
