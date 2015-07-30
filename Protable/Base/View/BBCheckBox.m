//
//  BACheckBox.m
//  Adult
//
//  Created by houzhenyong on 14-7-26.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBCheckBox.h"

#define kSpacing        2       // 间距x2

@implementation BBCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutLabelAndImage
{
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(_offImage.size.width + kSpacing), 0, (_offImage.size.width + kSpacing));
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.titleLabel.bounds.size.width + kSpacing), 0, -(self.titleLabel.bounds.size.width + kSpacing));
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, kSpacing, 0, -kSpacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -kSpacing, 0, kSpacing);
    
//    NSLog(@"%f, %f", self.titleEdgeInsets.left, self.titleEdgeInsets.right);
//    NSLog(@"%f, %f", self.imageEdgeInsets.left, self.imageEdgeInsets.right);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutLabelAndImage];
}

@end
