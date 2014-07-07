//
//  BAAttributedTextView.m
//  lxCoretextParagraph
//
//  Created by hou zhenyong on 14-2-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAAttributedTextView.h"

@implementation BAAttributedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAttributedText:(BAAttributedText *)attributedText
{
    _attributedText = attributedText;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect drawRect = CGRectMake(self.attributedText.contentInsets.left,
                                 self.attributedText.contentInsets.top,
                                 rect.size.width - self.attributedText.contentInsets.left - self.attributedText.contentInsets.right,
                                 rect.size.height - self.attributedText.contentInsets.top - self.attributedText.contentInsets.bottom);
    [self.attributedText.attributedString drawInRect:drawRect];
}


@end
