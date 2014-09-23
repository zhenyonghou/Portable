//
//  BACollectionViewCell.m
//  lxLineCollectionView
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BACollectionViewCell.h"

@implementation BACollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_textLabel];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [self.textLabel sizeToFit];
    self.textLabel.center = self.contentView.center;
}

@end
