//
//  BASkinResourceManager.m
//  lxChangeSkin
//
//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASkinResourceManager.h"

NSString * const kSkinWillChangeNotification    = @"BA.SkinWillChangeNotification";
NSString * const kSkinChangeNotification        = @"BA.SkinChangeNotification";
NSString * const kSkinDidChangedNotification    = @"BA.SkinDidChangedNotification";

@implementation BASkinResourceManager

static BASkinResourceManager *instance;
+ (BASkinResourceManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BASkinResourceManager alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        NSString *skinPlistPath = [[NSBundle mainBundle] pathForResource:@"skin_list" ofType:@"plist"];
        _skinsPlist = [NSDictionary dictionaryWithContentsOfFile:skinPlistPath];

        _commonSkinPath = [self skinPathWithSkinFolderName:@"skin_common"];
        _commonFontColorPlist = [self contentForPlistFileWithSkinPath:_commonSkinPath];
    }
    return self;
}

- (void)changeSkinWithName:(NSString*)skinName
{
    if ([self.currentSkinName isEqualToString:skinName]) {
        return;
    }

    self.currentSkinPath = [self skinPathWithSkinName:skinName];
    self.currentSkinName = skinName;
    self.currentFontColorPlist = [self contentForPlistFileWithSkinPath:self.currentSkinPath];

    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinWillChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinDidChangedNotification object:self];
}

- (NSString*)filePathWithSkinName:(NSString*)skinName
{
    return [self.currentSkinPath stringByAppendingPathComponent:skinName];
}

#pragma mark- private methods

- (NSString*)skinPathWithSkinName:(NSString*)skinName
{
    NSString *skinFolder = [self.skinsPlist objectForKey:skinName];
    return [self skinPathWithSkinFolderName:skinFolder];
}

- (NSString*)skinPathWithSkinFolderName:(NSString*)skinFolderName
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:skinFolderName];
}

- (NSDictionary*)contentForPlistFileWithSkinPath:(NSString*)skinPath
{
    return [NSDictionary dictionaryWithContentsOfFile:[skinPath stringByAppendingPathComponent:@"font_color.plist"]];
}

@end
