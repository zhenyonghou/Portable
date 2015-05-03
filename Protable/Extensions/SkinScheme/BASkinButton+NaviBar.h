//
//  BASkinButton+NaviBar.h
//  Read
//
//  Created by houzhenyong on 15/3/19.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BASkinButton.h"

@interface BASkinButton (NaviBar)

+ (BASkinButton *)naviBarLeftButtonWithTarget:(id)target action:(SEL)action;
+ (BASkinButton *)naviBarRightButtonWithTarget:(id)target action:(SEL)action;

@end
