//
//  UIViewController+BAAdditions.m
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//


#import <objc/runtime.h>
#import "UIViewController+BAAdditions.h"
#import "ProtableDefines.h"
#import "UIColor+BAAdditions.h"
#import "BANaviBackButton.h"

#define USE_CUSTOMIZE_ITEM      0

#define TITLE_FONT_SIZE         18
#define NAVI_BAR_TEXT_COLOR     SKIN_COLOR(@"color_navi_title")


@implementation UIViewController (BAAdditions)

static char BAViewControllerEntryTypeKey;

- (void)setNewTitle:(NSString*)title
{
//    IOS6上在navibar上直接设置title很难看，所以使用了titleView，如果IOS7上设置title,下一级back button显示本级title, 使用titleView使返回按钮显示“返回”
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.textColor = SKIN_COLOR(@"color_navibar_title");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark- buttons

- (UIButton *)customizeButtonForTitle:(NSString*)title
                          normalColor:(UIColor*)normalColor
                     highlightedColor:(UIColor*)highlightedColor
                               target:(id)target
                               action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [button sizeToFit];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton*)customizeButtonForNormalImage:(UIImage *)normalImage
                          highlightedImage:(UIImage *)highlightedImage
                                    target:(id)target
                                    action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:normalImage forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 45, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton*)customizeLeftButtonForNormalImage:(UIImage *)normalImage
                              highlightedImage:(UIImage *)highlightedImage
                                        target:(id)target
                                        action:(SEL)action
{
    UIButton *button = [self customizeButtonForNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    if (IOS_VERSION >= 7.0) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    return button;
}

- (UIButton*)customizeRightButtonForNormalImage:(UIImage *)normalImage
                               highlightedImage:(UIImage *)highlightedImage
                                         target:(id)target
                                         action:(SEL)action
{
    UIButton *button = [self customizeButtonForNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    if (IOS_VERSION >= 7.0) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    return button;
}

- (UIBarButtonItem*)customizeBarButtonItemWithTitle:(NSString*)title
                                             target:(id)target
                                             action:(SEL)action

{
    UIBarButtonItem* buttonItem;
#ifdef USE_CUSTOMIZE_ITEM
    UIButton* button = [self customizeButtonForTitle:title normalColor:NAVI_BAR_TEXT_COLOR highlightedColor:[UIColor lightGrayColor] target:target action:action];
    buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
#else
    if (IOS_VERSION >= 7.0) {
        buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    } else {
        UIButton* button = [self customizeButtonForTitle:title normalColor:NAVI_BAR_TEXT_COLOR highlightedColor:[UIColor lightGrayColor] target:target action:action];
        buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
#endif
    return buttonItem;
}

- (UIBarButtonItem*)customizeBarButtonItemWithNormalImage:(UIImage *)normalImage
                                         highlightedImage:(UIImage *)highlightedImage
                                                   target:(id)target
                                                   action:(SEL)action
{
    UIBarButtonItem* buttonItem;
#ifdef USE_CUSTOMIZE_ITEM
    UIButton* button = [self customizeButtonForNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
#else
    if (IOS_VERSION >= 7.0) {
        buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:target action:action];
    } else {
        UIButton* button = [self customizeButtonForNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
        buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
#endif
    return buttonItem;
}


#pragma mark- for left

- (void)setLeftItemWithNormalImage:(UIImage *)normalImage
                  highlightedImage:(UIImage *)highlightedImage
                            action:(SEL)action
{
    [self setLeftItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setLeftItemWithNormalImage:(UIImage *)normalImage
                  highlightedImage:(UIImage *)highlightedImage
                            target:(id)target
                            action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setLeftItemWithTitle:(NSString*)title
                      action:(SEL)action
{
    [self setLeftItemWithTitle:title target:self action:action];
}

- (void)setLeftItemWithTitle:(NSString*)title
                      target:(id)target
                      action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithTitle:title target:target action:action];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setLeftItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setLeftItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

#pragma mark- for right

- (void)setRightItemWithNormalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage
                             action:(SEL)action
{
    [self setRightItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setRightItemWithNormalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage
                             target:(id)target
                             action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightItemWithTitle:(NSString*)title
                       action:(SEL)action
{
    [self setRightItemWithTitle:title target:self action:action];
}

- (void)setRightItemWithTitle:(NSString*)title
                       target:(id)target
                       action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithTitle:title target:target action:action];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark- for back
// 经验证，backBarButtonItem设置image不可取，但是这样在IOS6上又难看了点

- (void)setBackItemWithTitle:(NSString *)title
                      target:(id)target
                      action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithTitle:title target:target action:action];
    self.navigationItem.backBarButtonItem = customizeButtonItem;
}

- (void)setBackItemWithNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage action:(SEL)action
{
    [self setBackItemWithNormalImage:normalImage highlightedImage:highlightedImage target:self action:action];
}

- (void)setBackItemWithNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action
{
    BANaviBackButton *button = [[BANaviBackButton alloc] initWithFrame:CGRectZero];
    [button setNormalImage:normalImage highlightedImage:highlightedImage];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackItemWithCustomView:button];
}

- (void)setBackItemWithCustomView:(UIView *)customView
{
    if (IOS_VERSION >= 7) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-8.0f];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
    } else {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}

- (void)setEntryType:(BAViewControllerEntryType)entryType
{
    objc_setAssociatedObject(self, &BAViewControllerEntryTypeKey, @(entryType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BAViewControllerEntryType)entryType
{
    NSNumber *val = objc_getAssociatedObject(self, &BAViewControllerEntryTypeKey);
    return [val integerValue];
}

@end
