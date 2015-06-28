//
//  UIViewController+Protable.h
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


@interface UIViewController (Protable)

@property (nonatomic, assign) BAViewControllerEntryType entryType;

- (void)setNewTitle:(NSString*)title;

// buttons & items

// navibar left item

- (void)setLeftItemWithNormalImage:(UIImage *)normalImage
                  highlightedImage:(UIImage *)highlightedImage
                            action:(SEL)action;

- (void)setLeftItemWithNormalImage:(UIImage *)normalImage
                  highlightedImage:(UIImage *)highlightedImage
                            target:(id)target
                            action:(SEL)action;


- (void)setLeftItemWithTitle:(NSString*)title
                      action:(SEL)action;

- (void)setLeftItemWithTitle:(NSString*)title
                      target:(id)target
                      action:(SEL)action;

- (void)setLeftItemWithCustomView:(UIView *)customView;

- (void)setLeftItem:(UIBarButtonItem *)barButtonItem;

// navibar right item

- (void)setRightItemWithNormalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage
                             action:(SEL)action;

- (void)setRightItemWithNormalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage
                             target:(id)target
                             action:(SEL)action;


- (void)setRightItemWithTitle:(NSString*)title
                       action:(SEL)action;

- (void)setRightItemWithTitle:(NSString*)title
                       target:(id)target
                       action:(SEL)action;

- (void)setRightItemWithCustomView:(UIView *)customView;

- (void)setRightItem:(UIBarButtonItem *)barButtonItem;

// navibar back item

- (void)setBackItemWithTitle:(NSString *)title
                      target:(id)target
                      action:(SEL)action;

- (void)setBackItemWithNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage action:(SEL)action;

- (void)setBackItemWithNormalImage:(UIImage*)normalImage
                  highlightedImage:(UIImage*)highlightedImage
                            target:(id)target
                            action:(SEL)action;

- (void)setBackItemWithCustomView:(UIView *)customView;

@end
