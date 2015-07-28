//
//  UINavigationItem+Protable.h
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationItem(Protable)

- (void)setItemTitle:(NSString *)title;

- (void)setLeftBarButtonItemWithNormalImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                     action:(SEL)action;

- (void)setLeftBarButtonItemWithTitle:(NSString*)title
                               target:(id)target
                               action:(SEL)action;

- (void)setRightBarButtonItemWithNormalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                                      target:(id)target
                                      action:(SEL)action;

- (void)setRightBarButtonItemWithTitle:(NSString*)title
                                target:(id)target
                                action:(SEL)action;

- (void)setBackBarButtonItemWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action;

- (void)setBackBarButtonItemWithNormalImage:(UIImage*)normalImage
                           highlightedImage:(UIImage*)highlightedImage
                                     target:(id)target
                                     action:(SEL)action;

- (void)setBackItemWithCustomView:(UIView *)customView;
@end
