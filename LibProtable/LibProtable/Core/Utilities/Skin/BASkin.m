//
//  BASkin.m
//  lxChangeSkin
//
//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASkin.h"
#import "BASkinResourceManager.h"
#import "UIColor+BAAdditions.h"

#define kImageCacheTotalLimit  0

@interface BASkin () {
    NSCache *_imageCache;
}

@end

@implementation BASkin

static BASkin *instance;
+ (BASkin*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BASkin alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _imageCache = [[NSCache alloc] init];
        [_imageCache setCountLimit:0];
        [_imageCache setTotalCostLimit:kImageCacheTotalLimit];
//        [_imageCache setCountLimit:0];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSkinWillChanged:)
                                                     name:kSkinWillChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onSkinWillChanged:(NSNotification*)notification
{
    [self clearImageCache];
}

- (UIImage *)imageForKey:(NSString*)key
{
    if (nil == key) {
        NSLog(@"warning: %s", __FUNCTION__);
        return nil;
    }
    
    UIImage *image = [_imageCache objectForKey:key];
    if (nil == image) {
        NSString *imageName = [NSString stringWithFormat:@"%@.png", key];
        NSString *imagePath = [[BASkinResourceManager sharedInstance].currentSkinPath stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (nil == image) {
            NSString *imagePath = [[BASkinResourceManager sharedInstance].commonSkinPath stringByAppendingPathComponent:imageName];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    
    if (nil == image) {
        NSLog(@"warning: 图片没找到! %@", key);
    }
    return image;
}

- (UIColor *)colorForKey:(NSString *)key
{
    NSString *colorString = [[BASkinResourceManager sharedInstance].currentFontColorPlist objectForKey:key];
    if (nil == colorString) {
        colorString = [[BASkinResourceManager sharedInstance].commonFontColorPlist objectForKey:key];
    }
    
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
    NSDictionary *fontDictionary = [[BASkinResourceManager sharedInstance].currentFontColorPlist objectForKey:key];
    if (nil == fontDictionary) {
        fontDictionary = [[BASkinResourceManager sharedInstance].commonFontColorPlist objectForKey:key];
    }
    
    NSString *name = [fontDictionary objectForKey:@"name"];
    NSInteger size = [[fontDictionary objectForKey:@"size"] integerValue];
    return [UIFont fontWithName:name size:size];
}

- (void)clearImageCache
{
    [_imageCache removeAllObjects];
}


@end
