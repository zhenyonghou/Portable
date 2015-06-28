//
//  BASkinBlankCell.h
//  Read
//
//  Created by houzhenyong on 15/2/3.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BBTableViewCell.h"

@interface BASkinBlankCell : BBTableViewCell

/**
 *  该类不再接收换肤通知，只留出一个换肤接口，子类中如需要换肤，
 *  需要调用 [super onChangeSkin:notification];
 */
- (void)onChangeSkin:(NSNotification *)notification;

@end
