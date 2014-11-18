//
//  SDImageSelectCell.m
//  shuidi2
//
//  Created by houzhenyong on 14-3-4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BASelectFlagGridCell.h"

@interface BASelectFlagGridCell()

@end

@implementation BASelectFlagGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];

        _selectIconButton = [[BASwitchButton alloc] initWithFrame:CGRectZero offImage:nil onImage:nil target:self selector:@selector(onTouchedWithSelectedState:)];
        _selectIconButton.backgroundColor = [UIColor clearColor];
        _selectIconButton.bounceAnimate = YES;
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

- (void)onTouchedWithSelectedState:(BASwitchButton*)switchButton
{
    BOOL isSelected = switchButton.stateOn;

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectFlagGridCell:stateChanged:)]) {
        [self.delegate selectFlagGridCell:self stateChanged:isSelected];
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
