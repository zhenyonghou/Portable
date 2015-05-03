//
//  BASView.h
//  Read
//
//  Created by zhenyonghou on 15/2/1.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^ConfigSkinBlock)(void);

@interface BASkinView : UIView

/** changeSkinBlock适用于在外部类中换肤的情况
 *  接到换肤通知时，changeSkinBlock会被执行.
 *  如果执行changeSkinBlock，则不会执行onChangeSkin方法.
 */
@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

- (void)onChangeSkin;

@end
