//
//  BBRoundCornerImageView.m
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "BBRoundCornerImageView.h"

@implementation BBRoundCornerImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_coverImageView];
}

- (void)setCoverNormalImage:(UIImage *)coverNormalImage highlightedImage:(UIImage *)highlightedImage
{
    self.coverImageView.image = coverNormalImage;
    self.coverImageView.highlightedImage = highlightedImage;
}

//- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
//{
//    [self sd_setImageWithURL:url placeholderImage:placeholderImage];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _coverImageView.frame = self.bounds;
}


@end
