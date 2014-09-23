//
//  UIViewController+BAAdditions.h
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BAAdditions)

+ (void)customizeBars;

- (void)configViewControllerEdges;

- (void)setNewTitle:(NSString*)title;

- (void)setLeftItemWithAction:(SEL)action
                        image:(UIImage*)image;

- (void)setLeftItemWithCustomView:(UIView *)customView;

- (void)setRightItemWithAction:(SEL)action
                         title:(NSString*)title;

- (void)setRightItemWithAction:(SEL)action
                         image:(UIImage*)image;

- (void)setBackItemWithAction:(SEL)action
                        title:(NSString*)title;

- (void)setRightItemWithCustomView:(UIView *)customView;

@end
