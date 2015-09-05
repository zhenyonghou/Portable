//
//  BBRatingBar.m
//
//  Created by mumuhou on 15/8/17.
//  Copyright (c) 2015年 mumuhou. All rights reserved.
//

#import "BBRatingBar.h"

static NSInteger kDefaultNumberOfStars     = 5;

@interface BBRatingBar ()

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation BBRatingBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _starSize = CGSizeZero;
    _score = 0;

    _starFillImage = [UIImage imageNamed:@"star_fill"];
    _starFillHalfImage = [UIImage imageNamed:@"star_fill_half"];
    _starEmptyImage = [UIImage imageNamed:@"star_empty"];

    [self setNumberOfStars:kDefaultNumberOfStars];
}

- (void)setNumberOfStars:(NSInteger)numberOfStars
{
    _numberOfStars = numberOfStars;
    for (UIImageView *imageView in _imageViewArray) {
        [imageView removeFromSuperview];
    }

    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:_numberOfStars];

    for (int k = 0; k < _numberOfStars; ++k) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_empty"]];
        [_imageViewArray addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void)setScore:(CGFloat)score
{
    _score = score;
    [self refreshScore];
}

- (void)refreshScore
{
    for (int k = 0; k < _numberOfStars; ++k) {
        UIImageView *imageView = _imageViewArray[k];
        if (_score - k >= 1.0) {
            imageView.image = _starFillImage;
        } else if ((_score - k) > 0.1 && (_score - k) < 0.5) {
            imageView.image = _starFillHalfImage;
        } else if ((_score - k) >= 0.5) {
            imageView.image = _starFillImage;
        } else {
            imageView.image = _starEmptyImage;
        }
    }
    [self setNeedsLayout];
}

- (void)setStarSize:(CGSize)starSize
{
    _starSize = starSize;
    [self setNeedsLayout];
}

- (void)layoutStars
{
    UIImageView *firstImageView = _imageViewArray[0];
    
    if (CGSizeEqualToSize(_starSize, CGSizeZero)) {
        _starSize = firstImageView.image.size;
    }

    CGFloat interitemSpacing = (self.frame.size.width - _starSize.width *_numberOfStars)  / (_numberOfStars - 1);

    for (int k = 0; k < _imageViewArray.count; ++k) {
        UIImageView *imageView = _imageViewArray[k];
        imageView.frame = CGRectMake((interitemSpacing + _starSize.width) * k,
                                     (self.bounds.size.height - _starSize.height) / 2,
                                     _starSize.width,
                                     _starSize.height);
    }
}

- (void)layoutSubviews {
    [self layoutStars];
}

- (void)setStarFillImage:(UIImage *)starFillImage
{
    _starFillImage = starFillImage;
//    [self refreshScore];
}

- (void)setStarFillHalfImage:(UIImage *)starFillHalfImage
{
    _starFillHalfImage = starFillHalfImage;
//    [self refreshScore];
}

- (void)setStarEmptyImage:(UIImage *)starEmptyImage
{
    _starEmptyImage = starEmptyImage;
//    [self refreshScore];
}

@end
