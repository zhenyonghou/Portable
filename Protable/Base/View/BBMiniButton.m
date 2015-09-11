//
//  BBMiniButton.m
//  LxButtonExtension
//
//  Created by mumuhou on 15/9/11.
//  Copyright (c) 2015年 mumuhou. All rights reserved.
//

#import "BBMiniButton.h"

@implementation BBMiniButton

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
    _enableTouchWidth = 44.f;
    _enableTouchHeight = 44.f;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = _enableTouchWidth - bounds.size.width;
    CGFloat heightDelta = _enableTouchHeight - bounds.size.height;
    
    NSAssert(widthDelta >= 0 && heightDelta >= 0, @"BBMiniButton failed reason for enableTouchWidth or enableTouchHeight.");
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);	//注意这里是负数，扩大了之前的bounds的范围
    return CGRectContainsPoint(bounds, point);
}

@end
