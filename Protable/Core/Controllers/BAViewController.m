//
//  BAViewController.m
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BAViewController.h"
#import "ProtableCore.h"

@interface BAViewController ()

@end

@implementation BAViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = SKIN_COLOR(@"view_bg_color");
    
    if (IOS_VERSION < 7.0) {
        self.wantsFullScreenLayout = YES;
        self.navigationController.navigationBar.translucent = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeSkin:) name:kSkinChangeNotification object:nil];
}

- (void)unloadViewWhenMemoryWarning
{
    // 子类中去实现
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (![self isViewLoaded]) {
        return;
    }
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 6.0f) {      // 注：原来的代码中这里是 <, 我觉得不对，才改过来的。
        if (self.view.window == nil) { // 是否是正在使用的视图
            [self unloadViewWhenMemoryWarning];
            self.view = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [MobClick event:NSStringFromClass([self class]) label:@"show"];
//
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

// 换肤协议，子类去实现
- (void)onChangeSkin:(NSNotification*)notification
{

}

@end
