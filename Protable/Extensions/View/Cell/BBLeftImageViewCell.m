//
//  BALeftViewCell.m
//  LibProtable
//
//  Created by houzhenyong on 14-6-21.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#define kImageViewPadding       5

#import "BBLeftImageViewCell.h"

@implementation BBLeftImageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_leftImageView];
    }
    return self;
}

- (void)setLeftImage:(UIImage*)image imageFrame:(CGRect)frame text:(NSString*)text
{
    self.leftImageView.image = image;
    self.leftImageView.frame = frame;
    self.textLabel.text = text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat textLabelOffset = self.leftImageView.mm_right + kImageViewPadding;

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    self.textLabel.frame = CGRectMake(textLabelOffset, (self.mm_height - labelSize.height)/2, labelSize.width, labelSize.height);
}

@end
