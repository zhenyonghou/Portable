//  UIDevice+UIDeviceExt.h
//  Created by hou zhenyong on 13-12-13.

#import <UIKit/UIKit.h>

@interface UIDevice (Protable)

// 获取设备型号，如："iPhone4,1"
+ (NSString*) deviceModel;

// 获取设备名称，如：iPhone5, iPhone5S
+ (NSString*) deviceName;

// 检测是否越狱
+ (BOOL)isJailbroken;

// 获得运营商信息
+ (NSString*)getCellularProviderName;

+ (NSString*) deviceNameWithDeviceModel:(BOOL)shouldIncludeDeviceModel;

// 获取本地IP
+ (NSArray *)localIPAddresses;

+ (NSString*)IDFV;

//+ (NSString*)IDFA;

@end
