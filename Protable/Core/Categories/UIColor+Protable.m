//
//  UIColor+BAAdditions.m
//  lxChangeSkin
//
//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "UIColor+Protable.h"

@implementation UIColor (Protable)

+ (void)getRed:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue fromHexColorString:(NSString*)hexColorString
{
    if ([hexColorString length] < 6){//长度不合法
        return;
    }
    
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]){
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] != 6){
        return;
    }
    //分解三种颜色的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    *red = (float)r / 255.0f;
    *green = (float)g / 255.0f;
    *blue = (float)b / 255.0f;
}

+ (UIColor*)colorWithHexString:(NSString *)hexColorString {
    CGFloat red = 0.f;
    CGFloat green = 0.f;
    CGFloat blue = 0.f;
    
    [[self class] getRed:&red green:&green blue:&blue fromHexColorString:hexColorString];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString *)hexColorString alphaString:(NSString *)alphaString
{
    unsigned int a;
    [[NSScanner scannerWithString:alphaString] scanHexInt:&a];
    
    CGFloat red = 0.f;
    CGFloat green = 0.f;
    CGFloat blue = 0.f;
    
    [[self class] getRed:&red green:&green blue:&blue fromHexColorString:hexColorString];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:(float)a/100.f];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

@end
