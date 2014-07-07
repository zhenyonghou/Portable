//
//  BAEnableTouchCell.m
//  PregnancyTracking
//
//  Created by hou zhenyong on 13-10-14.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import "BAEnableTouchCell.h"

@implementation BAEnableTouchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setBackgroundImage:(UIImage*)image hlBackgroundImage:(UIImage*)hlImage
{
    self.backgroundImageView.image = image;
    self.backgroundImageView.highlightedImage = hlImage;

    self.backgroundImageView.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesMoved:touches withEvent:event];
}

@end
