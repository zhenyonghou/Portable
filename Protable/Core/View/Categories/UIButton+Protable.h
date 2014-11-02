//
//  UIButton+Protable.h
//  Adult
//
//  Created by houzhenyong on 14-8-12.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Protable)

/**
 得到自适应大小的Button
 由于Button交互特性，在自适应大小的同时，也需要设置最小的size，此函数就为满足这种需求。
 */
- (void)fitSizeWithLimitMinimumSize:(CGSize)minimumSize;

/**
 仅适用于左边图片右边文字的时候
 */
- (void)setTitleAndImageHorizontalSpacing:(CGFloat)spacing;

@end
