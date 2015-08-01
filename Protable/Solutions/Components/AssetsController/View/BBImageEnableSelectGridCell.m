//
//  COImageEnableSelectGridCell.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-19.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBImageEnableSelectGridCell.h"

@implementation BBImageEnableSelectGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUnselectedIcon:SKIN_IMAGE(@"icon_photo_select") selectedIcon:SKIN_IMAGE(@"icon_photo_select_hl")];
    }
    return self;
}

- (void)setSelectedFlag:(BOOL)isSelected animated:(BOOL)animated
{
    BBSwitchButtonState state = isSelected ? BBSwitchButtonStateOn : BBSwitchButtonStateOff;
    self.selectIconButton.switchState = state;
}

@end
