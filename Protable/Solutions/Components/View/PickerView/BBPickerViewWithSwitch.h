//
//  BAPickerViewWithSwitch.h
//  Pregnancy
//
//  Created by houzhenyong on 14-6-8.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBMaskPickerView.h"

@interface BBPickerViewWithSwitch : BBMaskPickerView

//for subclass
@property (nonatomic, weak) BBSwitchButton *switchButton;

- (void)setObserverForSwitchButton:(BBSwitchButton*)switchButton;

- (void)removeObserverForSwitchButton;

@end
