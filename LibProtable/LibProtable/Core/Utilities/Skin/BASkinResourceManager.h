//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//  换肤的思路：
//  1. 建skins.plist文件，记录各个皮肤的folder。
//  2. 在工程目录里为每种皮肤分别建立folder，导入XCode为实体目录，所谓
//  实体目录，就是运行在模拟器上或手机上时候，该目录还存在，要建立实体目录，
//  就要在导入时候选择Create folder references for any added
//  folders. 会发现，在Xcode中实体目录是蓝色的，其它非实体目录是黄色的。
//  由于部分皮肤图片是公用的，所以会有skin_common目录，当在专属皮肤目录
//  中找不到皮肤文件时再从skin_common中找。将相同名称的皮肤图片分别放在
//  对应的专属皮肤folder中.
//  3. 在ViewController和View的基类中监听kSkinChangeNotification通知，
//  在派生类中实现监听回调。

#import <Foundation/Foundation.h>

extern NSString * const kSkinWillChangeNotification;
extern NSString * const kSkinChangeNotification;
extern NSString * const kSkinDidChangedNotification;

@interface BASkinResourceManager : NSObject

// common skin
@property (nonatomic, copy) NSString *commonSkinPath;
// font_color.plist存储的数据
@property (nonatomic, strong) NSDictionary *commonFontColorPlist;

// 当前皮肤名称
@property (nonatomic, copy) NSString *currentSkinName;

// skins.plist存储的数据
@property (nonatomic, strong) NSDictionary *skinsPlist;

// 当前皮肤读取路径
@property (nonatomic, copy) NSString *currentSkinPath;
// font_color.plist存储的数据
@property (nonatomic, strong) NSDictionary *currentFontColorPlist;

+ (BASkinResourceManager*)sharedInstance;

- (void)changeSkinWithName:(NSString*)skinName;

@end