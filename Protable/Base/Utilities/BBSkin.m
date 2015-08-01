//
//  BBSkin.m
//  Demo
//
//  Created by zhenyonghou on 15/6/28.
//  Copyright © 2015年 hou zhenyong. All rights reserved.
//

#import "BBSkin.h"

@implementation BBSkinResourceManager {
    NSDictionary *_resourceData;
}

- (id)init
{
    if (self = [super init]) {
        NSString *skinPlistPath = [[NSBundle mainBundle] pathForResource:@"font_color" ofType:@"plist"];
        _resourceData = [NSDictionary dictionaryWithContentsOfFile:skinPlistPath];
    }
    return self;
}

- (id)dataForKey:(NSString *)key
{
    return _resourceData[key];
}

@end

#pragma mark- BBSkinResourceManager

@implementation BBSkin {
    BBSkinResourceManager *_resourceManager;
}

static BBSkin *instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BBSkin alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _resourceManager = [[BBSkinResourceManager alloc] init];
    }
    return self;
}

- (UIImage *)imageForKey:(NSString*)key
{
    UIImage *image = [UIImage imageNamed:key];
    if (!image) {
        NSLog(@"warning: 图片找不到：%@", key);
    }
    return image;
}

- (UIColor *)colorForKey:(NSString *)key
{
    NSString *colorString = [_resourceManager dataForKey:key];
    
    NSArray *colorHexStringAndAlpha = [colorString componentsSeparatedByString:@","];
    
    UIColor *color = [UIColor blackColor];
    if ([colorHexStringAndAlpha count] == 1) {
        color = [UIColor colorWithHexString:colorHexStringAndAlpha[0]];
    } else if ([colorHexStringAndAlpha count] == 2) {
        color = [UIColor colorWithHexString:colorHexStringAndAlpha[0] alphaString:colorHexStringAndAlpha[1]];
    } else {
        NSLog(@"warning: 这个颜色找不到：%@", key);
    }
    
    return color;
}

- (UIFont *)fontForKey:(NSString *)key
{
    NSDictionary *fontDictionary = [_resourceManager dataForKey:key];
    
    NSString *name = [fontDictionary objectForKey:@"name"];
    NSInteger size = [[fontDictionary objectForKey:@"size"] integerValue];
    return [UIFont fontWithName:name size:size];
}


@end
