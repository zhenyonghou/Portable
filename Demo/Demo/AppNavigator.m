//
//  AppNavigator.m
//  Colleague
//
//  Created by houzhenyong on 14-5-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "AppNavigator.h"
#import "AppDelegate.h"
#import "BBTabBarController.h"

#import "DECoreExamplesViewController.h"
#import "DEExtensionsExamplesViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"

@interface AppNavigator()

@property (nonatomic, strong) BBTabBarController *tabBarController;

@end

@implementation AppNavigator

static AppNavigator * navigator = nil;

+ (AppNavigator*)navigator
{
	@synchronized(self) {
		if (navigator == nil) {
			navigator = [[AppNavigator alloc] init];
		}
	}
	return navigator;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AppDelegate *)sharedAppDelegate
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (void)openTabBarControllers
{
    if (!self.tabBarController) {
        [self buildTabBarViewControllers];
    }
    [self sharedAppDelegate].window.rootViewController = self.tabBarController;
}

- (void)buildTabBarViewControllers
{
    BBTabBarItem *barItem0 = [[BBTabBarItem alloc] initWithTitle:@"Core Examples"
                                                           image:SKIN_IMAGE(@"tabbar_first")
                                                   selectedImage:SKIN_IMAGE(@"tabbar_first_hl")];
    
    BBTabBarItem *barItem1 = [[BBTabBarItem alloc] initWithTitle:@"Extensions Examples"
                                                           image:SKIN_IMAGE(@"tabbar_second")
                                                   selectedImage:SKIN_IMAGE(@"tabbar_second_hl")];
    
    BBTabBarItem *barItem2 = [[BBTabBarItem alloc] initWithTitle:@"第3页"
                                                           image:SKIN_IMAGE(@"tabbar_third")
                                                   selectedImage:SKIN_IMAGE(@"tabbar_third_hl")];
    
    BBTabBarItem *barItem3 = [[BBTabBarItem alloc] initWithTitle:@"第4页"
                                                           image:SKIN_IMAGE(@"tabbar_forth")
                                                   selectedImage:SKIN_IMAGE(@"tabbar_forth_hl")];
    
    UINavigationController *navi0 = [[UINavigationController alloc] initWithRootViewController:[[DECoreExamplesViewController alloc] init]];
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:[[DEExtensionsExamplesViewController alloc] init]];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:[[ThirdViewController alloc] init]];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:[[ForthViewController alloc] init]];

    self.tabBarController = [[BBTabBarController alloc] init];
    [self.tabBarController bb_setBarItems:@[barItem0, barItem1, barItem2, barItem3]];
    self.tabBarController.viewControllers = @[navi0, navi1, navi2, navi3];
}

@end
