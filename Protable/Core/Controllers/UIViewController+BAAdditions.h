//
//  UIViewController+BAAdditions.h
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BAViewControllerEntryType) {
    BAViewControllerEntryTypePush       = 0,
    BAViewControllerEntryTypePresent,
};

@interface UIViewController (BAAdditions)

@property (nonatomic, assign) BAViewControllerEntryType entryType;

- (void)setNewTitle:(NSString*)title;

- (void)setLeftItemWithAction:(SEL)action
                        image:(UIImage*)image;

- (void)setLeftItemWithCustomView:(UIView *)customView;

- (void)setRightItemWithAction:(SEL)action
                         title:(NSString*)title;

- (void)setRightItemWithAction:(SEL)action
                         image:(UIImage*)image;

- (void)setBackItemWithNormalImage:(UIImage*)normalImage
                  highlightedImage:(UIImage*)highlightedImage
                         tintColor:(UIColor*)tintColor
                            action:(SEL)action;

- (void)setRightItemWithCustomView:(UIView *)customView;

@end
