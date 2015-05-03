//
//  BASkinBackButton.h
//  Read
//
//  Created by houzhenyong on 15/2/6.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BAAdditions.h"
#import "BANaviBackButton.h"

typedef void(^ConfigSkinBlock)(void);

@interface BASkinBackButton : BANaviBackButton

@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

+ (BASkinBackButton *)naviBarBackButtonWithTarget:(id)target action:(SEL)action;

@end
