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
    
    CGFloat rightMargin = 10;
    if (self.accessoryImageView.image) {
        rightMargin = self.accessoryImageView.left - 5;
    }
    
    self.rightView.right = rightMargin;
}

@end
