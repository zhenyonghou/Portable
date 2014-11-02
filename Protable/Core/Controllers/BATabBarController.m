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
#import "UIImage+ImageWithColor.h"

@implementation BATabBarItem

- (id)initWithTitle:(NSString*)title
      selectedImage:(UIImage*)selectedImage
    unselectedImage:(UIImage*)unselectedImage
     viewController:(UIViewController*)viewController
{
    if (self = [super init]) {
        _title = title;
        _selectedImage = selectedImage;
        _unselectedImage = unselectedImage;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITabBarItem*)buildTabBarItemWithTabBarItem:(BATabBarItem*)barItem
{
    UITabBarItem *item;
    if (IOS_VERSION >= 7.0) {
        item = [[UITabBarItem alloc] initWithTitle:barItem.title image:barItem.unselectedImage selectedImage:barItem.selectedImage];
    } else {
        item = [[UITabBarItem alloc] initWithTitle:barItem.title image:nil tag:0];
        [item setFinishedSelectedImage:barItem.selectedImage withFinishedUnselectedImage:barItem.unselectedImage];
    }
    
    [item setTitlePositionAdjustment:UIOffsetMake(0, -1)];
    
    NSDictionary* normalAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11],
                                     NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                     NSKernAttributeName : @(1.2)};
    [item setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary* selectedAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11],
                                       NSForegroundColorAttributeName : SKIN_COLOR(@"navibar_bg_color"),
                                       NSKernAttributeName : @(1.2)};
    [item setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    return item;
}

- (void)setBarItems:(NSArray *)barItems
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[barItems count]];
    for (BATabBarItem *oneItem in barItems) {
        UITabBarItem* tabBarItem = [self buildTabBarItemWithTabBarItem:oneItem];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:oneItem.viewController];
        naviController.tabBarItem = tabBarItem;
        [mutableArray addObject:naviController];
    }
    
    self.viewControllers = mutableArray;
}

@end
