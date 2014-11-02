//
//  BACustomize.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BACustomize.h"

@implementation BACustomize

+ (void)customizeBars
{
    // 设置导航栏背景色，IOS6中，设置tintColor只能设置颜色，不能扁平，所以得设置图片
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:SKIN_COLOR(@"navibar_bg_color")];
        [[UINavigationBar appearance] setTintColor:SKIN_COLOR(@"navibar_text_color")];    // 设置返回按钮及文字颜色
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"navibar_bg_color")] forBarMetrics:UIBarMetricsDefault];
    }
    
    // 去掉iOS6中讨厌的 border
    if (IOS_VERSION < 7.0) {
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
    }
    
    //    if (IOS_VERSION >= 7.0) {
    //        // 注释掉，还是使用默认的<形吧，知道有这个方法就行
    //        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_btn.png"]];
    //        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_btn.png"]];
    //    }
    
    // 设置导航栏的返回按钮
    if (IOS_VERSION < 7.0) {
        UIImage *naviBackImage = [SKIN_IMAGE(@"navi_back") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:naviBackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *dic = @{UITextAttributeFont: [UIFont systemFontOfSize:17], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
    
    // status bar
    // 必须在XXX-info.plist中设置：View controller-based status bar appearance 为 NO
    if (IOS_VERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }

    // tabbar
    if (IOS_VERSION >= 7.0) {
        [UITabBar appearance].tintColor = SKIN_COLOR(@"navibar_bg_color");
        [UITabBar appearance].barTintColor = [UIColor whiteColor];
    } else {
        // iOS6中给 TabBar 设置 tintColor 也不够扁平，还是老老实实设置背景图片，并去掉 Tab 选中时的高光效果
        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
//        NSDictionary *dic = @{UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextColor:tabBarTintColor};
//        [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateSelected];
    }
}




@end
