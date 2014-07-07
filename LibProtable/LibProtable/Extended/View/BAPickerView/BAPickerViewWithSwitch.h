//
//  BAPickerViewWithSwitch.h
//  Pregnancy
//
//  Created by houzhenyong on 14-6-8.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAMaskPickerView.h"

@interface BAPickerViewWithSwitch : BAMaskPickerView

//for subclass
@property (nonatomic, weak) BASwitchButton *switchButton;

- (void)setObserverForSwitchButton:(BASwitchButton*)switchButton;

- (void)removeObserverForSwitchButton;

@end
