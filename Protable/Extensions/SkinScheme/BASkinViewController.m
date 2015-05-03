//
//  BASkinViewController.m
//  Read
//
//  Created by houzhenyong on 15/3/27.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinViewController.h"
#import "BASkinBackButton.h"

@interface BASkinViewController ()

@end

@implementation BASkinViewController

- (id)init
{
    self = [super init];
    if (self) {
        _isManulChangeSkin = NO;
        _autoAddBackButtonItem = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinChangeNotification object:nil];
}

- (void)viewDidLoad {
    _autoAddBackButtonItem = YES;
    
    [super viewDidLoad];

    if (_autoAddBackButtonItem) {
        [self addBackButton];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeSkin:) name:kSkinChangeNotification object:nil];
}

- (void)addBackButton
{
    if ([self.navigationController.viewControllers count] > 1) {
        BASkinBackButton *backButton = [BASkinBackButton naviBarBackButtonWithTarget:self action:@selector(onBack)];
        [self setBackItemWithCustomView:backButton];
        __weak __typeof(backButton) weakBackButton = backButton;
        backButton.configSkinBlock = ^(void) {
            [weakBackButton setImage:SKIN_IMAGE(@"BackArrowWhite") forState:UIControlStateNormal];
            [weakBackButton setImage:SKIN_IMAGE(@"BackArrowWhite_highlight") forState:UIControlStateHighlighted];
        };
    }
}

// 换肤协议，子类去实现
- (void)onChangeSkin:(NSNotification*)notification
{
    self.view.backgroundColor = SKIN_COLOR(@"color_view_background");
    if (!_isManulChangeSkin) {
//        [self changeTitleColor:SKIN_COLOR(@"color_navi_title")];
    }
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
