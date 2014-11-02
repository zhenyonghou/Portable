//
//  BARightViewCell.m
//  LibProtable
//
//  Created by houzhenyong on 14-6-22.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BARightViewCell.h"

@implementation BARightViewCell

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
    
    CGFloat rightMargin = self.width - 13;
    if (self.accessoryImageView.image) {
        rightMargin = self.accessoryImageView.left - 5;
    }
    
    [self.rightView setRight:rightMargin top:(self.height - self.rightView.height) / 2];
}

- (void)updateRithView
{
    [self layoutSubviews];
//    [self setNeedsDisplay];
}

@end
