//
//  UIViewController+BAAdditions.m
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//


#import <objc/runtime.h>
#import "UIViewController+Navi.h"
#import "UINavigationItem+Protable.h"

#define USE_CUSTOMIZE_ITEM      0

#define TITLE_FONT_SIZE         18
#define NAVI_BAR_TEXT_COLOR     SKIN_COLOR(@"color_navi_title")


@implementation UIViewController (Navi)

static char BBViewControllerEntryTypeKey;

- (void)setNaviTitle:(NSString *)title {
    [self.navigationItem setItemTitle:title];
}

#pragma mark- left button item

- (void)setNaviLeftItemWithNormalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                                action:(SEL)action
{
    [self setNaviLeftItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setNaviLeftItemWithNormalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                                target:(id)target
                                action:(SEL)action
{
    [self.navigationItem setLeftBarButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
}

- (void)setNaviLeftItemWithTitle:(NSString*)title
                          action:(SEL)action
{
    [self setNaviLeftItemWithTitle:title target:self action:action];
}

- (void)setNaviLeftItemWithTitle:(NSString*)title
                          target:(id)target
                          action:(SEL)action
{
    [self.navigationItem setLeftBarButtonItemWithTitle:title target:target action:action];
}

- (void)setNaviLeftItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setNaviLeftItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

#pragma mark- right button item

- (void)setNaviRightItemWithNormalImage:(UIImage *)normalImage
                       highlightedImage:(UIImage *)highlightedImage
                                 action:(SEL)action
{
    [self setNaviLeftItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setNaviRightItemWithNormalImage:(UIImage *)normalImage
                       highlightedImage:(UIImage *)highlightedImage
                                 target:(id)target
                                 action:(SEL)action
{
    [self.navigationItem setLeftBarButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
}

- (void)setNaviRightItemWithTitle:(NSString*)title
                           action:(SEL)action
{
    [self setNaviLeftItemWithTitle:title target:self action:action];
}

- (void)setNaviRightItemWithTitle:(NSString*)title
                           target:(id)target
                           action:(SEL)action
{
    [self.navigationItem setLeftBarButtonItemWithTitle:title target:target action:action];
}

- (void)setNaviRightItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setNaviRightItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

#pragma mark- back button item

- (void)setNaviBackItemWithNormalImage:(UIImage*)normalImage
                      highlightedImage:(UIImage*)highlightedImage
                                action:(SEL)action
{
    [self setNaviBackItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setNaviBackItemWithNormalImage:(UIImage*)normalImage
                      highlightedImage:(UIImage*)highlightedImage
                                target:(id)target
                                action:(SEL)action
{
    [self.navigationItem setBackBarButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
}

- (void)setNaviBackItemWithTitle:(NSString *)title
                      target:(id)target
                      action:(SEL)action
{
    [self.navigationItem setBackBarButtonItemWithTitle:title target:target action:action];
}

#pragma mark- 

- (void)setEntryType:(BBViewControllerEntryType)entryType
{
    objc_setAssociatedObject(self, &BBViewControllerEntryTypeKey, @(entryType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BBViewControllerEntryType)entryType
{
    NSNumber *val = objc_getAssociatedObject(self, &BBViewControllerEntryTypeKey);
    return [val integerValue];
}

@end
