//
//  UIViewController+Protable.h
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BBViewControllerEntryType) {
    BBViewControllerEntryTypePush       = 0,
    BBViewControllerEntryTypePresent,
};


@interface UIViewController (Navi)

@property (nonatomic, assign) BBViewControllerEntryType entryType;

- (void)setNaviTitle:(NSString *)title;

- (void)setNaviLeftItemWithNormalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                                action:(SEL)action;

- (void)setNaviLeftItemWithNormalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                                target:(id)target
                                action:(SEL)action;

- (void)setNaviLeftItemWithTitle:(NSString*)title
                          action:(SEL)action;

- (void)setNaviLeftItemWithTitle:(NSString*)title
                          target:(id)target
                          action:(SEL)action;

- (void)setNaviLeftItemWithCustomView:(UIView *)customView;

- (void)setNaviLeftItem:(UIBarButtonItem *)barButtonItem;


// navibar right item

- (void)setNaviRightItemWithNormalImage:(UIImage *)normalImage
                       highlightedImage:(UIImage *)highlightedImage
                                 action:(SEL)action;

- (void)setNaviRightItemWithNormalImage:(UIImage *)normalImage
                       highlightedImage:(UIImage *)highlightedImage
                                 target:(id)target
                                 action:(SEL)action;

- (void)setNaviRightItemWithTitle:(NSString*)title
                           action:(SEL)action;

- (void)setNaviRightItemWithTitle:(NSString*)title
                           target:(id)target
                           action:(SEL)action;

- (void)setNaviRightItemWithCustomView:(UIView *)customView;

- (void)setNaviRightItem:(UIBarButtonItem *)barButtonItem;


// navibar back item

- (void)setNaviBackItemWithNormalImage:(UIImage*)normalImage
                      highlightedImage:(UIImage*)highlightedImage
                                action:(SEL)action;

- (void)setNaviBackItemWithNormalImage:(UIImage*)normalImage
                      highlightedImage:(UIImage*)highlightedImage
                                target:(id)target
                                action:(SEL)action;

- (void)setNaviBackItemWithTitle:(NSString *)title
                          target:(id)target
                          action:(SEL)action;

@end
