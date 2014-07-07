//
//  BAUserConfigurator.h
//  PregnancyTracking
//
//  Created by hou zhenyong on 13-10-10.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 与项目相关的配置，再从BAUserConfigurator扩展吧

@interface BAUserConfigurator : NSObject

+ (BAUserConfigurator*)sharedInstance;

@property (nonatomic, strong) NSString *currentSkinName;

@property (nonatomic, strong) NSString *serverVersion;

@end
