//
//  BATabBarController.h
//  lxTabBar
//
//  Created by hou zhenyong on 14-1-14.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.

#import <UIKit/UIKit.h>

@interface BATabBarItem : NSObject

@property (nonatomic, strong) UITabBarItem *tabBarItem;
@property (nonatomic, strong) UIViewController *viewController;

- (id)initWithTitle:(NSString *)title
        normalImage:(UIImage *)normalImage
      selectedImage:(UIImage *)selectedImage
     viewController:(UIViewController *)viewController;

@end


@interface BATabBarController : UITabBarController

- (void)setBarItems:(NSArray *)barItems;

@end
