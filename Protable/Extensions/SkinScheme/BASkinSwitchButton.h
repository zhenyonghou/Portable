//
//  BASkinSwitchButton.h
//  Read
//
//  Created by houzhenyong on 15/2/2.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASwitchButton.h"

typedef void(^ConfigSkinBlock)(void);

@interface BASkinSwitchButton : BASwitchButton

@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

// for subview
- (void)onChangeSkin;

@end
