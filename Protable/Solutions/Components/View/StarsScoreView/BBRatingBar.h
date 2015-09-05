//
//  BBRatingBar.h
//
//  Created by mumuhou on 15/8/17.
//  Copyright (c) 2015年 mumuhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBRatingBar : UIView

@property (nonatomic, assign) NSInteger numberOfStars; // 默认5

/**
 *  以下是3种状态的star image.
 */
@property (nonatomic, strong) UIImage *starFillImage;
@property (nonatomic, strong) UIImage *starFillHalfImage;
@property (nonatomic, strong) UIImage *starEmptyImage;

/**
 * score规则：
 * 0.1~0.4x 是0.5，0.5x~1是进1
 */
@property (nonatomic, assign) CGFloat score;

/**
 *  starSize
 *  如果不设置，就按照默认star image的大小
 */
@property (nonatomic, assign) CGSize starSize;

@end
