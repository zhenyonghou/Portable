//
//  SFTabBarController.m
//  lxTabBar
//
//  Created by hou zhenyong on 14-1-14.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BATabBarController.h"
#import "ProtableDefines.h"
#import "UIViewController+BAAdditions.h"

@implementation BATabBarItem

- (id)initWithTitle:(NSString *)title
        normalImage:(UIImage *)normalImage
      selectedImage:(UIImage *)selectedImage
     viewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                    image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                            selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _viewController = viewController;
    }
    return self;
}

@end

////////////////

@interface BATabBarController ()

@end

@implementation BATabBarController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setBarItems:(NSArray *)barItems
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[barItems count]];
    for (BATabBarItem *oneItem in barItems) {
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:oneItem.viewController];
        naviController.tabBarItem = oneItem.tabBarItem;
        [mutableArray addObject:naviController];
    }
    
    self.viewControllers = mutableArray;
}

@end
