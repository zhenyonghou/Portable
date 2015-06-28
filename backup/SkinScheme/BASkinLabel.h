//
//  BASkinLabel.h
//  Read
//
//  Created by houzhenyong on 15/2/2.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfigSkinBlock)(void);

@interface BASkinLabel : UILabel

@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

// for subview
- (void)onChangeSkin;

@end
