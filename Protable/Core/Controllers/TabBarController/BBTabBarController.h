//
//  BBTabBarController.h
//  BBTabBar
//
//  Created by zhenyonghou on 15/6/27.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
/**
 *  TODO: 增加badge view
 */

#import <UIKit/UIKit.h>
#import "BBTabBarItem.h"



@interface BBTabBarController : UITabBarController

- (void)bb_setBarItems:(NSArray *)items;

@end

