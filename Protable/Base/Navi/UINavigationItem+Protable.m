//
//  UINavigationItem+Protable.m
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "UINavigationItem+Protable.h"
#import "BBNaviBackButton.h"

#define TITLE_FONT_SIZE         18
#define NAVI_BAR_TEXT_COLOR     SKIN_COLOR(@"color_navi_title")

@implementation UINavigationItem(Protable)

- (void)setItemTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.textColor = SKIN_COLOR(@"color_navibar_title");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.titleView = titleLabel;
}

- (void)setLeftBarButtonItemWithNormalImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                     action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self barButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    self.leftBarButtonItem = customizeButtonItem;
}

- (void)setLeftBarButtonItemWithTitle:(NSString*)title
                               target:(id)target
                               action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self barButtonItemWithTitle:title target:target action:action];
    self.leftBarButtonItem = customizeButtonItem;
}

- (void)setRightBarButtonItemWithNormalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                                      target:(id)target
                                      action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self barButtonItemWithNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    self.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightBarButtonItemWithTitle:(NSString*)title
                                target:(id)target
                                action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self barButtonItemWithTitle:title target:target action:action];
    self.rightBarButtonItem = customizeButtonItem;
}

- (void)setBackBarButtonItemWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action
{
    UIBarButtonItem *customizeButtonItem = [self barButtonItemWithTitle:title target:target action:action];
    self.backBarButtonItem = customizeButtonItem;
}

// 经验证，backBarButtonItem设置image不可取
- (void)setBackBarButtonItemWithNormalImage:(UIImage*)normalImage
                           highlightedImage:(UIImage*)highlightedImage
                                     target:(id)target
                                     action:(SEL)action
{
    BBNaviBackButton *button = [[BBNaviBackButton alloc] initWithFrame:CGRectZero];
    [button setNormalImage:normalImage highlightedImage:highlightedImage];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackItemWithCustomView:button];
}

- (void)setBackItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-8.0f];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
}

#pragma mark- private

- (UIBarButtonItem*)barButtonItemWithNormalImage:(UIImage *)normalImage
                                highlightedImage:(UIImage *)highlightedImage
                                          target:(id)target
                                          action:(SEL)action
{
    UIBarButtonItem* buttonItem;
#ifdef USE_CUSTOMIZE_ITEM
    UIButton* button = [self customizeButtonForNormalImage:normalImage highlightedImage:highlightedImage target:target action:action];
    buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
#else
    buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:target action:action];
#endif
    return buttonItem;
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

- (UIBarButtonItem*)barButtonItemWithTitle:(NSString*)title
                                    target:(id)target
                                    action:(SEL)action

{
    UIBarButtonItem* buttonItem;
#ifdef USE_CUSTOMIZE_ITEM
    UIButton* button = [self customizeButtonForTitle:title normalColor:NAVI_BAR_TEXT_COLOR highlightedColor:[UIColor lightGrayColor] target:target action:action];
    buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
#else
    buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
#endif
    return buttonItem;
}



@end
