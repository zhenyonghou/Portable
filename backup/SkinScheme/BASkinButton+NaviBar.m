//
//  BASkinButton+NaviBar.m
//  Read
//
//  Created by houzhenyong on 15/3/19.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinButton+NaviBar.h"

@implementation BASkinButton (NaviBar)

+ (BASkinButton *)naviBarLeftButtonWithTarget:(id)target action:(SEL)action
{
    BASkinButton* button = [[BASkinButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (IOS_VERSION >= 7.0) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return button;
}

+ (BASkinButton *)naviBarRightButtonWithTarget:(id)target action:(SEL)action
{
    BASkinButton* button = [[BASkinButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (IOS_VERSION >= 7.0) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return button;
}

@end
