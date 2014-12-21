//
//  UIViewController+BAAdditions.m
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#define TITLE_FONT_SIZE         18

#import "UIViewController+BAAdditions.h"
#import "ProtableDefines.h"
#import "UIColor+BAAdditions.h"

@implementation UIViewController (BAAdditions)



- (void)setNewTitle:(NSString*)title
{
//    IOS6上在navibar上直接设置title很难看，所以使用了titleView，如果IOS7上设置title,下一级back button显示本级title, 使用titleView使返回按钮显示“返回”
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.textColor = SKIN_COLOR(@"navibar_text_color");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (UIButton*)customizeButtonForTitle:(NSString*)title
                         normalColor:(UIColor*)normalColor
                    highlightedColor:(UIColor*)highlightedColor
                               image:(UIImage*)image
                              action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title && title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:SKIN_COLOR(@"navibar_text_color") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button sizeToFit];
    } else if (image) {
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 45, 44);
    }
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIBarButtonItem*)customizeBarButtonItemWithAction:(SEL)action
                                               image:(UIImage*)image
{
    UIBarButtonItem* buttonItem;
    if (IOS_VERSION >= 7.0) {
        buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:action];
    } else {
        UIButton* button = [self customizeButtonForTitle:nil
                                             normalColor:nil
                                        highlightedColor:nil
                                                   image:image
                                                  action:action];
        buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return buttonItem;
}

- (UIBarButtonItem*)customizeBarButtonItemWithAction:(SEL)action
                                               title:(NSString*)title
{
    UIBarButtonItem* buttonItem;
    if (IOS_VERSION >= 7.0) {
        buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    } else {
        UIButton* button = [self customizeButtonForTitle:title
                                             normalColor:SKIN_COLOR(@"navibar_text_color")
                                        highlightedColor:[UIColor lightGrayColor]
                                                   image:nil
                                                  action:action];
        buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return buttonItem;
}

- (void)setLeftItemWithAction:(SEL)action
                        image:(UIImage*)image
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action image:image];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setLeftItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = customizeButtonItem;
}

- (void)setRightItemWithAction:(SEL)action
                         title:(NSString*)title
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action title:title];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightItemWithAction:(SEL)action
                         image:(UIImage*)image
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action image:image];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

- (void)setRightItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = customizeButtonItem;
}

// 经验证，backBarButtonItem设置image不可取，但是这样在IOS6上又难看了点
//- (void)setBackItemWithAction:(SEL)action
//                        title:(NSString*)title
//{
//    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
//    self.navigationItem.backBarButtonItem = buttonItem;
//}

- (void)setBackItemWithNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage tintColor:(UIColor*)tintColor action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [button setTitleColor:tintColor forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (IOS_VERSION >= 7) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, -7.0f)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(1.0f, 0.0f, -1.0f, 0.0f)];
        [button sizeToFit];
        button.width = button.width + 7.f;
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-8.0f];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        backBarButtonItem.tintColor = tintColor;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, -7.0f)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(1.0f, 3.0f, -1.0f, -3.0f)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [button sizeToFit];
        button.width = button.width + 7.f;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}

@end
