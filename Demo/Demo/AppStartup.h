//
//  AppStartup.h
//  Colleague
//
//  Created by houzhenyong on 14-5-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StartupBlock) (void);

@interface AppStartup : NSObject

+ (void)settingForAppStartup;

@end
