//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASwitchButton.h"
#import "UIView+Bounce.h"

@implementation BASwitchButton

- (id)initWithFrame:(CGRect)frame offImage:(UIImage*)offImage onImage:(UIImage*)onImage
{
    if (self = [self initWithFrame:frame]) {
        [self setOffImage:offImage onImage:onImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bounceAnimate = NO;
        _manualSwitch = NO;
        _switchState = BASwitchButtonStateOff;
        _ignoreTouch = NO;
    }
    return self;
}

- (void)setOffImage:(UIImage*)offImage onImage:(UIImage*)onImage
{
    _offImage = offImage;
    _onImage = onImage;
    
    [self setSwitchState:_switchState];
}

- (void)addTarget:(id)target switchAction:(SEL)action
{
    _target = target;
    _switchAction = action;
    [self addTarget:self action:@selector(touchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideAction
{
    if (_target && !_ignoreTouch) {
        if (!self.manualSwitch) {
            [self setSwitchState:!_switchState];
            
            if (self.bounceAnimate && self.switchState) {
                [self.imageView bounce:0.3];
            }
        }
        
        SuppressPerformSelectorLeakWarning([_target performSelector:_switchAction withObject:self]);
    }
}

- (void)setSwitchState:(BASwitchButtonState)switchState animated:(BOOL)animated
{
    [self setSwitchState:switchState];
    
    if (animated) {
        if (self.bounceAnimate && self.switchState) {
            [self.imageView bounce:0.3];
        }
    }
}

- (void)setSwitchState:(BASwitchButtonState)switchState
{
    _switchState = switchState;
    if (BASwitchButtonStateOff == _switchState) {
        [self setImage:_offImage forState:UIControlStateNormal];
        [self setImage:_offImage forState:UIControlStateHighlighted];
    } else {
        [self setImage:_onImage forState:UIControlStateNormal];
        [self setImage:_onImage forState:UIControlStateHighlighted];
    }
}


@end
