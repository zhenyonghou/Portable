//
//  UIButton+Protable.m
//  Adult
//
//  Created by houzhenyong on 14-8-12.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "UIButton+Protable.h"

@implementation UIButton (Protable)

- (void)setTitleAndImageHorizontalSpacing:(CGFloat)spacing
{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, -spacing / 2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0, spacing / 2);
}

@end
