//
//  BBDeviceID.h
//  Demo
//
//  Created by mumuhou on 15/8/8.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//  refer to https://blog.onliquid.com/persistent-device-unique-identifier-ios-keychain/

#import <Foundation/Foundation.h>

@interface BBDeviceID : NSObject

+ (NSString *)uniqueId;

@end
