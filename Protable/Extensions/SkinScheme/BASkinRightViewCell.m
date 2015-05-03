//
//  BARightViewCell.m
//  LibProtable
//
//  Created by houzhenyong on 14-6-22.

//

#import "BASkinRightViewCell.h"

@implementation BASkinRightViewCell

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
    
    CGFloat rightMargin = self.width - 15;
    if (self.accessoryImageView.image) {
        rightMargin = self.accessoryImageView.left - 15;
    }
    
    [self.rightView setRight:rightMargin top:(self.height - self.rightView.height) / 2];
}

- (void)updateRithView
{
    [self layoutSubviews];
//    [self setNeedsDisplay];
}

@end
