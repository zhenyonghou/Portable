//
//  AppNavigator.m
//  Colleague
//
//  Created by houzhenyong on 14-5-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "AppNavigator.h"
#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"

@interface AppNavigator()

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

- (id)init
{
    if (self = [super init]) {
    }
    return self;
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
        [self setupTabBarViewControllers];
    }
    [self sharedAppDelegate].window.rootViewController = self.tabBarController;
}

- (void)setupTabBarViewControllers
{
    BATabBarItem *barItem0 = [[BATabBarItem alloc] initWithTitle:@"第1页"
                                                   selectedImage:SKIN_IMAGE(@"tabbar_first_hl")
                                                 unselectedImage:SKIN_IMAGE(@"tabbar_first")
                                                  viewController:[[FirstViewController alloc] init]];
    
    BATabBarItem *barItem1 = [[BATabBarItem alloc] initWithTitle:@"第2页"
                                                   selectedImage:SKIN_IMAGE(@"tabbar_second_hl")
                                                 unselectedImage:SKIN_IMAGE(@"tabbar_second")
                                                  viewController:[[SecondViewController alloc] init]];
                              
    BATabBarItem *barItem2 = [[BATabBarItem alloc] initWithTitle:@"第3页"
                                                   selectedImage:SKIN_IMAGE(@"tabbar_third_hl")
                                                 unselectedImage:SKIN_IMAGE(@"tabbar_third")
                                                  viewController:[[ThirdViewController alloc] init]];
    
    BATabBarItem *barItem3 = [[BATabBarItem alloc] initWithTitle:@"第4页"
                                                   selectedImage:SKIN_IMAGE(@"tabbar_forth_hl")
                                                 unselectedImage:SKIN_IMAGE(@"tabbar_forth")
                                                  viewController:[[ForthViewController alloc] init]];
    
    self.tabBarController = [[BATabBarController alloc] init];
    [self.tabBarController setBarItems:@[barItem0, barItem1, barItem2, barItem3]];
}

@end
