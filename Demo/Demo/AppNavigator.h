//
//  AppNavigator.h
//  Colleague
//
//  Created by houzhenyong on 14-5-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BATabBarController.h"

@interface AppNavigator : NSObject

//@property (nonatomic, strong) BATabBarController *tabBarController;

+ (AppNavigator*)navigator;

// 打开Tab controller
- (void)openTabBarControllers;

@end
