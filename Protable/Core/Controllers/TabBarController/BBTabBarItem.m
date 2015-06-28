//
//  MMTabBarButton.m
//  MMTabBar
//
//  Created by zhenyonghou on 15/6/27.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
//

#import "BBTabBarItem.h"

@implementation BBTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    if (self = [super init]) {
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
        
        _innerSpacing = 4;
        _attributedNormal = @{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor grayColor]};
        _attributedSelected = @{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor blackColor]};
        
        [self setImage:_image forState:BBTabBarItemViewStateNormal];
        [self setImage:_selectedImage forState:BBTabBarItemViewStateSelected];
        
        [self setTitle:title];
    }
    return self;
}


- (void)setImage:(nullable UIImage *)image forState:(BBTabBarItemViewState)state
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self addSubview:_imageView];
    }
    
    if (BBTabBarItemViewStateNormal == state) {
        _imageView.image = image;
    } else if (BBTabBarItemViewStateSelected == state) {
        _imageView.highlightedImage = image;
    }
}

- (void)setTitle:(nullable NSString *)title
{
    _title = title;
    
    if (title && title.length > 0) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self addSubview:_titleLabel];
        }

        _titleLabel.text = title;
        [self updateTitle];
    }
}

- (void)setTitleTextAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(BBTabBarItemViewState)state
{
    if (BBTabBarItemViewStateNormal == state) {
        _attributedNormal = attributes;
    } else if (BBTabBarItemViewStateSelected == state) {
        _attributedSelected = attributes;
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    _imageView.highlighted = _selected;
    [self updateTitle];
}

- (void)updateTitle
{
    if (_title && _title.length > 0) {
        if (_selected) {
            _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_title attributes:_attributedSelected];
        } else {
            _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_title attributes:_attributedNormal];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_titleLabel.text && _titleLabel.text.length > 0) {
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeZero];
        CGSize imageSize = _imageView.bounds.size;

        CGFloat imageStartingY = roundf((self.bounds.size.height - imageSize.height - titleSize.height) / 2);
        
        _imageView.frame = CGRectMake((self.bounds.size.width - _image.size.width) / 2,
                                      imageStartingY,
                                      imageSize.width,
                                      imageSize.height);
        
        _titleLabel.frame = CGRectMake((self.bounds.size.width - titleSize.width) / 2,
                                       imageStartingY + imageSize.height + _innerSpacing,
                                       titleSize.width,
                                       titleSize.height);
        
    } else {
        _imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
}

@end
