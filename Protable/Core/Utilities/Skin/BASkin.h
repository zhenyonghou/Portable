//
//  BASkin.h
//  lxChangeSkin
//
//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BASkin : NSObject

+ (BASkin*)sharedInstance;

- (UIImage *)imageForKey:(NSString*)key;

- (UIColor *)colorForKey:(NSString *)key;

- (UIFont *)fontForKey:(NSString *)key;

- (void)clearImageCache;

@end

#define SKIN_IMAGE(key)      [[BASkin sharedInstance] imageForKey:(key)]
#define SKIN_COLOR(key)      [[BASkin sharedInstance] colorForKey:(key)]
#define SKIN_FONT(key)       [[BASkin sharedInstance] fontForKey:(key)]

// font name
// 方正兰亭黑(手动加入的字体)
#define FONT_NAME_FZLTH     @"FZLanTingHei-R-GBK"

// 系统字体
#define FONT_NAME_SYSTEM    @"Helvetica"

// 华文黑体-light
#define LIGHT_HEITI_FONT    @"STHeitiSC-Light"

// 华文黑体-medium
#define MED_HEITI_FONT      @"STHeitiSC-Medium"
