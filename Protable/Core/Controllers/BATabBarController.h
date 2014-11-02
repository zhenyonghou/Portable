//
//  BATabBarController.h
//  lxTabBar
//
//  Created by hou zhenyong on 14-1-14.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//  TODO:tabbar上字体颜色可设置

#import <UIKit/UIKit.h>

@interface BATabBarItem : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIImage* selectedImage;
@property (nonatomic, strong) UIImage* unselectedImage;
@property (nonatomic, strong) UIViewController *viewController;

- (id)initWithTitle:(NSString*)title
      selectedImage:(UIImage*)selectedImage
    unselectedImage:(UIImage*)unselectedImage
     viewController:(UIViewController*)viewController;

@end


@interface BATabBarController : UITabBarController

- (void)setBarItems:(NSArray *)barItems;

@end
