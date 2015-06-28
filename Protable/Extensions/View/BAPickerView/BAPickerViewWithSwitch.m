//
//  BAPickerViewWithSwitch.m
//  Pregnancy
//
//  Created by houzhenyong on 14-6-8.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAPickerViewWithSwitch.h"

@implementation BAPickerViewWithSwitch

- (void)dealloc
{
    [self removeObserverForSwitchButton];
}

- (void)setObserverForSwitchButton:(BBSwitchButton*)switchButton
{
    [self removeObserverForSwitchButton];
    self.switchButton = switchButton;
    [self.switchButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObserverForSwitchButton
{
    if (self.switchButton) {
        [self.switchButton removeObserver:self forKeyPath:@"selected"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selected"] && [object isEqual:self.switchButton]) {
        [self show:self.switchButton.isSelected];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate cancelPickerView:self];
//    [self dismiss];
}

@end
