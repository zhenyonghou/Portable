//
//  BARightViewCell.m
//  LibProtable
//
//  Created by houzhenyong on 14-6-22.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBRightViewCell.h"

@implementation BBRightViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self.rightView superview]) {
        [self addSubview:self.rightView];
    }
    
    CGFloat rightMargin = self.mm_width - 13;
    if (self.accessoryImageView.image) {
        rightMargin = self.accessoryImageView.mm_left - 5;
    }
    
    [self.rightView mm_setRight:rightMargin top:(self.mm_height - self.rightView.mm_height) / 2];
}

- (void)updateRithView
{
    [self layoutSubviews];
//    [self setNeedsDisplay];
}

@end
