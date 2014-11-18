//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASwitchButton.h"
#import "UIView+Bounce.h"

@implementation BASwitchButton

- (id)initWithFrame:(CGRect)frame offImage:(UIImage*)offImage onImage:(UIImage*)onImage
{
    if (self = [super initWithFrame:frame]) {
        _offImage = offImage;
        _onImage = onImage;
        _bounceAnimate = NO;
        [self setOffImage:_offImage onImage:_onImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           offImage:(UIImage*)offImage
            onImage:(UIImage*)onImage
             target:(id)target
           selector:(SEL)selector
{
    self = [self initWithFrame:frame offImage:offImage onImage:onImage];
    if (self) {
        [self addTarget:target switchSelector:selector];
    }
    return self;
}

- (void)setOffImage:(UIImage*)offImage onImage:(UIImage*)onImage
{
    [self setImage:offImage forState:UIControlStateNormal];
    [self setImage:onImage forState:UIControlStateSelected];
}

- (void)addTarget:(id)target switchSelector:(SEL)selector
{
    _target = target;
    _touchedSelector = selector;
    [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStateOn:(BOOL)stateOn
{
    if (stateOn == _stateOn) {
        return;
    }

    _stateOn = stateOn;
    self.selected = _stateOn;
}

- (void)touchAction
{
    self.stateOn = !self.stateOn;

    if (_target) {
        if (self.bounceAnimate && self.stateOn) {
            [self.imageView bounce:0.3];
        }
        SuppressPerformSelectorLeakWarning([_target performSelector:_touchedSelector withObject:self]);
    }
}

@end
