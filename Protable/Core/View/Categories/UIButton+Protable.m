//
//  UIButton+Protable.m
//  Adult
//
//  Created by houzhenyong on 14-8-12.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "UIButton+Protable.h"

@implementation UIButton (Protable)

- (void)fitSizeWithLimitMinimumSize:(CGSize)minimumSize
{
    CGSize fitSize = [self sizeThatFits:CGSizeZero];
    CGPoint originalPoint = self.frame.origin;
    self.frame = CGRectMake(originalPoint.x, originalPoint.y, MAX(fitSize.width, minimumSize.width), MAX(fitSize.height, minimumSize.height));
}

- (void)setTitleAndImageHorizontalSpacing:(CGFloat)spacing
{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, -spacing / 2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0, spacing / 2);
}

@end
