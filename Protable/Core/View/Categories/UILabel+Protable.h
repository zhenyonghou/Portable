//
//  UILabel+Protable.h
//  lxImageTextButton
//
//  Created by houzhenyong on 14-8-12.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//  包括：UILabel的大小自适应

#import <UIKit/UIKit.h>

@interface UILabel (Protable)

/**
 给定宽度，行数，自适应高度，maxHeight为0表示不限制
 注意，前提是已经设置好了font,text
 */
- (void)fitSizeWithConstantWidth:(CGFloat)width limitedLines:(NSUInteger)numberOfLines;


/**
 给定宽度，自适应高度，有高度限制
 注意，前提是已经设置好了font,text
 */
- (void)fitSizeWithConstantWidth:(CGFloat)width limitedHeight:(NSUInteger)maxHeight;

/**
 给定宽度，行数，自适应高度
 注意，前提是已经设置好了font
 */
- (void)setText:(NSString*)text constantWidth:(CGFloat)width limitedLines:(NSUInteger)numberOfLines;

/**
 给定宽度，自适应高度，有高度限制
 注意，前提是已经设置好了font
 */
- (void)setText:(NSString*)text constantWidth:(CGFloat)width limitedHeight:(NSUInteger)limitedHeight;

@end
