//
//  BASkinViewController.h
//  Read
//
//  Created by houzhenyong on 15/3/27.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BAViewController.h"

@interface BASkinViewController : BAViewController

@property (nonatomic, assign) BOOL isManulChangeSkin;

@property (nonatomic, assign) BOOL autoAddBackButtonItem;
// 子类重写该函数
- (void)onChangeSkin:(NSNotification*)notification;

- (void)onBack;

@end
