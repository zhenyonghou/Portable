//
//  BBRoundCornerImageView.h
//  当有圆角ImageView需求时，使用它使滑动更流畅，减少卡顿
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBRoundCornerImageView : UIImageView

/**
 *  盖在ImageView上的一层镂空Image图
 */
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

- (void)setCoverNormalImage:(UIImage *)coverNormalImage highlightedImage:(UIImage *)highlightedImage;

@end
