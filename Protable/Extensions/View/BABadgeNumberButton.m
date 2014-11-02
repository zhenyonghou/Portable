//
//  BABadgeNumberButton.m
//  houzhenyong
//
//  Created by houzhenyong on 14-3-14.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BABadgeNumberButton.h"

#define TEXT_FONT   9

@implementation BABadgeNumberButton

- (id)initWithFrame:(CGRect)frame withMaximumNumber:(NSUInteger)maximumNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _maximumNumber = maximumNumber;
        _badgeNumber = 0;
    }
    return self;
}

- (void)setBadgeNumber:(NSUInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    
    NSString* numberText = @"";
    if (_badgeNumber > 0) {
        if (_badgeNumber <= _maximumNumber) {
            numberText = [NSString stringWithFormat:@"%d", _badgeNumber];
        }
        else {
            numberText = [NSString stringWithFormat:@"%d+", _maximumNumber];
        }
        
        if (!_badgeLabel) {
            _badgeLabel = [[UILabel alloc] init];
            _badgeLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
            _badgeLabel.textColor = [UIColor whiteColor];
            _badgeLabel.backgroundColor = [UIColor redColor];
            _badgeLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        [self addSubview:_badgeLabel];
        
        _badgeLabel.text = numberText;
        CGSize fitSize = [_badgeLabel sizeThatFits:CGSizeZero];
        
        if (numberText.length == 1) {
            fitSize.height *= 1.1;
            fitSize.width = fitSize.height;
        } else if (numberText.length == 2){
            fitSize.width *= 1.7;
            fitSize.height *= 1.1;
        } else if (numberText.length == 3) {
            fitSize.width *= 1.4;
            fitSize.height *= 1.1;
        }
        
        _badgeLabel.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);
        _badgeLabel.layer.cornerRadius = fitSize.height * 0.5;
        _badgeLabel.layer.masksToBounds = YES;
        
        [self setNeedsLayout];
    } else {
        [self clearBadge];
    }
}

- (void)badgeNumberAdd:(NSUInteger)number
{
    _badgeNumber += number;
    [self setBadgeNumber:number];
    [self setNeedsLayout];
}

- (void)clearBadge
{
    _badgeNumber = 0;
    _badgeLabel.text = @"";
    [_badgeLabel removeFromSuperview];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _badgeLabel.center = CGPointMake(self.imageView.right + _badgeLabel.frame.size.width/3, self.imageView.top);
}

@end
