//
//  BARightViewCell.h
//  LibProtable
//
//  Created by houzhenyong on 14-6-22.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAEnableTouchCell.h"

@interface BARightViewCell : BAEnableTouchCell

@property (nonatomic, strong) UIView *rightView;    // default is nil

- (void)updateRithView;

@end
