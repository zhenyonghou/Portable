//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASwitchButton.h"
#import "UIView+Bounce.h"

@implementation BASwitchButton

- (id)initWithFrame:(CGRect)frame
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage
             target:(id)target
       switchAction:(SEL)action
{
    self = [self initWithFrame:frame normalImage:normalImage selectedImage:selectedImage];
    if (self) {
        [self addTarget:target switchAction:action];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame normalImage:(UIImage*)normalImage selectedImage:(UIImage*)selectedImage
{
    if (self = [super initWithFrame:frame]) {
        _bounceAnimate = NO;
        [self setNormalImage:normalImage selectedImage:selectedImage];
    }
    return self;
}

- (void)setNormalImage:(UIImage*)normalImage selectedImage:(UIImage*)selectedImage
{
    _normalImage = normalImage;
    _selectedImage = selectedImage;
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)addTarget:(id)target switchAction:(SEL)action
{
    _target = target;
    _switchAction = action;
    [self addTarget:self action:@selector(touchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideAction
{
    if (_target) {
        //        if (self.bounceAnimate && self.stateOn) {
        //            [self.imageView bounce:0.3];
        //        }
        self.selected = !self.isSelected;
        SuppressPerformSelectorLeakWarning([_target performSelector:_switchAction withObject:self]);
    }
}

@end
