//
//  SDImageSelectCell.m
//  shuidi2
//
//  Created by houzhenyong on 14-3-4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BBSelectFlagGridCell.h"

@interface BBSelectFlagGridCell()

@end

@implementation BBSelectFlagGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];

        _selectIconButton = [[BBSwitchButton alloc] initWithFrame:CGRectZero offImage:nil onImage:nil];
        [_selectIconButton addTarget:self switchAction:@selector(onTouchedWithSelectedState:)];
        _selectIconButton.backgroundColor = [UIColor clearColor];
//        _selectIconButton.bounceAnimate = YES;
        [self.contentView addSubview:_selectIconButton];
        
        _iconRightMargin = 0.f;
        _iconTopMargin = 0.f;
    }
    return self;
}

- (void)setImage:(UIImage*)image
{
    _imageView.image = image;
}

- (void)setUnselectedIcon:(UIImage *)unselectedIcon selectedIcon:(UIImage*)selectedIcon
{
    [_selectIconButton setOffImage:unselectedIcon onImage:selectedIcon];
    _iconSize = selectedIcon.size;
}

- (void)onTouchedWithSelectedState:(id)sender
{
    BBSwitchButton *button = sender;

    if (self.delegate && [self.delegate respondsToSelector:@selector(touchedFlagGridCell:shouldChangeState:)]) {
        if (![self.delegate touchedFlagGridCell:self shouldChangeState:button.switchState]) {

            BBSwitchButtonState newState = (button.switchState == BBSwitchButtonStateOn) ? BBSwitchButtonStateOff : BBSwitchButtonStateOn;
            button.switchState = newState;
            
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    _selectIconButton.frame = CGRectMake(self.frame.size.width - self.iconRightMargin * 2 - _iconSize.width,
                                         0,
                                         _iconSize.width + self.iconRightMargin * 2,
                                         _iconSize.height + self.iconTopMargin * 2);
    _selectIconButton.imageEdgeInsets = UIEdgeInsetsMake(self.iconTopMargin, self.iconRightMargin, self.iconTopMargin, self.iconRightMargin);
}

@end
