//
//  BBTableViewCell.m
//  Lx0624
//
//  Created by zhenyonghou on 15/6/26.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
//

#import "BBTableViewCell.h"

const CGFloat kAccessoryViewRightMargin   = 15;
const CGFloat kAccessoryViewLeftSpacing   = 5;

@implementation BBTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetting];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self internalSetting];
    }
    return self;
}

- (void)internalSetting
{
    self.backgroundColor = [UIColor whiteColor];
    _separatorLeftMargin = 15.f;
    
    _separatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = SKIN_COLOR(@"color_cell_separator");
    [self addSubview:_separatorLine];
    
    _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _separatorLine.frame = CGRectMake(_separatorLeftMargin,
                                      self.frame.size.height - 0.5,
                                      self.frame.size.width,
                                      0.5);
    
    if (self.accessoryImageView.image) {
        CGSize imageSize = self.accessoryImageView.image.size;
        self.accessoryImageView.frame = CGRectMake(self.mm_width - kAccessoryViewRightMargin - imageSize.width - kAccessoryViewLeftSpacing,
                                                   (self.mm_height - imageSize.height)/2,
                                                   imageSize.width,
                                                   imageSize.height);
        [self addSubview:self.accessoryImageView];
        self.textLabel.mm_width = (self.accessoryImageView.mm_left - kAccessoryViewLeftSpacing) - self.textLabel.mm_left;
    } else {
        [self.accessoryImageView removeFromSuperview];
        self.textLabel.mm_width = self.mm_right - self.textLabel.mm_left;
    }
}

@end
