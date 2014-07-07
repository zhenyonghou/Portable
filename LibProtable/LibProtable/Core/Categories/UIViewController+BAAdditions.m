//
//  UIViewController+BAAdditions.m
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#define TITLE_FONT_SIZE         18
#define NAVI_BAR_TEXT_COLOR     SKIN_COLOR(@"navibar_text_color")

#import "UIViewController+BAAdditions.h"
#import "ProtableDefines.h"
#import "UIColor+BAAdditions.h"
#import "UIImage+ImageWithColor.h"

@implementation UIViewController (BAAdditions)

+ (void)customizeBars
{
    // 设置导航栏背景色
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:SKIN_COLOR(@"navibar_bg_color")];
        // 设置返回按钮及文字颜色
        [[UINavigationBar appearance] setTintColor:NAVI_BAR_TEXT_COLOR];
    } else {
        // 设置tintColor只能设置颜色，不能扁平，所以得设置图片
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"navibar_bg_color")] forBarMetrics:UIBarMetricsDefault];
    }

//    if (IOS_VERSION >= 7.0) {
//        // 注释掉，还是使用默认的<形吧，知道有这个方法就行
//        //        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_btn.png"]];
//        //        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_btn.png"]];
//        
//        // 设置导航栏的标题风格，因为IOS6上navibar使用titleView（IOS6使用title字体显示太难看，所以使用titleView）, 所以这个设置只影响到IOS7
//        
//    }
    
    // 去掉iOS6中讨厌的 border
    if (IOS_VERSION < 7.0) {
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
    }
    
    // status bar
    // 必须在XXX-info.plist中设置：View controller-based status bar appearance 为 NO
    if (IOS_VERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
}

// 解决IOS6/7适配问题
- (void)configViewControllerEdges
{
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    } else {
        self.wantsFullScreenLayout = NO;        // 5.28 YES改为NO
    }
}

- (void)setNewTitle:(NSString*)title
{
//    IOS6上在navibar上直接设置title很难看，所以使用了titleView，如果IOS7上设置title,下一级back button显示本级title, 使用titleView使返回按钮显示“返回”
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.textColor = NAVI_BAR_TEXT_COLOR;
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
        [button setTitleColor:NAVI_BAR_TEXT_COLOR forState:UIControlStateNormal];
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
                                             normalColor:NAVI_BAR_TEXT_COLOR
                                        highlightedColor:[UIColor lightGrayColor]
                                                   image:nil
                                                  action:action];
        buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return buttonItem;
}

- (UIBarButtonItem*)customizeBarButtonItemWithCustomView:(UIView*)customView
{
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

- (NSArray*)buttonItemArrayForFitSystemWithItem:(UIBarButtonItem*)barButtonItem
{
    NSArray *buttonItems;
    
    if (IOS_VERSION >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = -10;
        buttonItems = @[negativeSpacer, barButtonItem];
    } else {
        buttonItems = @[barButtonItem];
    }
    return buttonItems;
}

- (void)setLeftItemWithAction:(SEL)action
                        image:(UIImage*)image
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action image:image];
    NSArray *buttonItems = [self buttonItemArrayForFitSystemWithItem:customizeButtonItem];
    [self.navigationItem setLeftBarButtonItems:buttonItems];
}

- (void)setLeftItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithCustomView:customView];
    NSArray *buttonItems = [self buttonItemArrayForFitSystemWithItem:customizeButtonItem];
    [self.navigationItem setLeftBarButtonItems:buttonItems];
}

- (void)setRightItemWithAction:(SEL)action
                         title:(NSString*)title
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action title:title];
    NSArray *buttonItems = [self buttonItemArrayForFitSystemWithItem:customizeButtonItem];
    [self.navigationItem setRightBarButtonItems:buttonItems];
}

- (void)setRightItemWithAction:(SEL)action
                         image:(UIImage*)image
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithAction:action image:image];
    NSArray *buttonItems = [self buttonItemArrayForFitSystemWithItem:customizeButtonItem];
    [self.navigationItem setRightBarButtonItems:buttonItems];
}

- (void)setRightItemWithCustomView:(UIView *)customView
{
    UIBarButtonItem *customizeButtonItem = [self customizeBarButtonItemWithCustomView:customView];
    NSArray *buttonItems = [self buttonItemArrayForFitSystemWithItem:customizeButtonItem];
    [self.navigationItem setRightBarButtonItems:buttonItems];
}

// 经验证，backBarButtonItem设置image不可取，但是这样在IOS6上又难看了点
- (void)setBackItemWithAction:(SEL)action
                        title:(NSString*)title
{
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    self.navigationItem.backBarButtonItem = buttonItem;
}

@end
