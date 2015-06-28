//
//  UIColor+BAAdditions.h
//  lxChangeSkin
//
//  Created by houzhenyong on 14-5-2.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Protable)

+ (UIColor*)colorWithHexString:(NSString *)hexColorString;

+ (UIColor*)colorWithHexString:(NSString *)hexColorString alphaString:(NSString *)alphaString;

+ (UIColor*)colorWithHex:(NSInteger)hexValue;

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

@end


#define COLOR(r,g,b)                                [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define COLOR_ALPHA(r,g,b,a)                        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define COLOR_HEX(hexValue)                         [UIColor colorWithHex:(hexValue)]

#define COLOR_ALPHA_HEX(hexValue, alphaValue)       [UIColor colorWithHex:(hexValue) alpha:(alphaValue)]


#define COLOR_HEXSTRING(hexString)                  [UIColor colorWithHexString:(hexString)]

#define COLOR_A_HEXSTRING(hexString, alphaString)   [UIColor colorWithHexString:(hexString) alphaString:(alphaString)]
