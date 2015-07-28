//
//  UILabel+Protable.m
//  lxImageTextButton
//
//  Created by houzhenyong on 14-8-12.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "UILabel+Protable.h"

@implementation UILabel (Protable)

/**
 给定宽度，行数，自适应高度
 注意，前提是已经设置好了font,text
 */
- (void)fitSizeWithConstantWidth:(CGFloat)width limitedLines:(NSUInteger)numberOfLines
{
    self.numberOfLines = numberOfLines;
    CGSize fitSize = [self sizeThatFits:CGSizeMake(width, 0)];
    CGPoint originalPoint = self.frame.origin;
    self.frame = CGRectMake(originalPoint.x, originalPoint.y, width, fitSize.height);
}

/**
 给定宽度，自适应高度，有高度限制，maxHeight为0表示不限制
 注意，前提是已经设置好了font,text
 */
- (void)fitSizeWithConstantWidth:(CGFloat)width limitedHeight:(NSUInteger)maxHeight
{
    self.numberOfLines = 0;
    CGSize fitSize = [self sizeThatFits:CGSizeMake(width, 0)];
    CGPoint originalPoint = self.frame.origin;
    self.frame = CGRectMake(originalPoint.x, originalPoint.y, fitSize.width, (maxHeight > 0) ? MIN(maxHeight, fitSize.height) : fitSize.height);
}

/**
 给定宽度，行数，自适应高度
 注意，前提是已经设置好了font
 */
- (void)setText:(NSString*)text constantWidth:(CGFloat)width limitedLines:(NSUInteger)numberOfLines
{
    self.text = text;
    [self fitSizeWithConstantWidth:width limitedLines:numberOfLines];
}

/**
 给定宽度，自适应高度，有高度限制
 注意，前提是已经设置好了font
 */
- (void)setText:(NSString*)text constantWidth:(CGFloat)width limitedHeight:(NSUInteger)maxHeight
{
    self.text = text;
    [self fitSizeWithConstantWidth:width limitedHeight:maxHeight];
}


@end
