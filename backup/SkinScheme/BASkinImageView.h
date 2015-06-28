//
//  BASkinImageView.h
//  Read
//
//  Created by houzhenyong on 15/3/13.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BAImageView.h"

typedef void(^ConfigSkinBlock)(void);

@interface BASkinImageView : BAImageView

@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

// 注意，子类在覆盖父类internalInitialize方法时，一定要先调用父类的commonInit方法
- (void)commonInit;

- (void)onChangeSkin;

@end
