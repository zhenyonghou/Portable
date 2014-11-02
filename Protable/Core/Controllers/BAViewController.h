//
//  BAViewController.h
//  Summer
//
//  Created by houzhenyong on 14-5-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BAAdditions.h"
//#import "SVProgressHUD.h"

@interface BAViewController : UIViewController

// 子类重写该函数
- (void)onChangeSkin:(NSNotification*)notification;

@end
