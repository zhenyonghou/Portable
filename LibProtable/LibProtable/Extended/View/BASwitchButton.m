//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 sfbest. All rights reserved.
//

#import "BASwitchButton.h"
#import "UIView+Bounce.h"

@implementation BASwitchButton

- (id)initWithFrame:(CGRect)frame
           offImage:(UIImage*)offImage
            onImage:(UIImage*)onImage
             target:(id)target
           selector:(SEL)selector
{
    self = [super initWithFrame:frame];
    if (self) {
        _offImage = offImage;
        _onImage = onImage;
        
        _target = target;
        _touchedSelector = selector;
        
        _bounceAnimate = NO;

        [self setImage:offImage forState:UIControlStateNormal];
        [self setImage:onImage forState:UIControlStateSelected];
        [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setOffImage:(UIImage*)offImage onImage:(UIImage*)onImage
{
    [self setImage:offImage forState:UIControlStateNormal];
    [self setImage:onImage forState:UIControlStateSelected];
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
        SuppressPerformSelectorLeakWarning([_target performSelector:_touchedSelector withObject:@(self.stateOn)]);
    }
}

@end
