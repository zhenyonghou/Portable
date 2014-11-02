//
//  BAEnableTouchImageView.m
//
//  Created by hou zhenyong on 14-3-31.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAEnableTouchImageView.h"

@implementation BAEnableTouchImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.exclusiveTouch = YES;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:_tapGestureRecognizer];
}

- (void)onTap:(UIGestureRecognizer*)gestureRecoginizer
{
    [self.delegate touchImageView:self];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.delegate touchImageView:self touch:[touches anyObject]];
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.delegate touchImageView:self touch:[touches anyObject]];
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.delegate touchImageView:self touch:[touches anyObject]];
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.delegate touchImageView:self touch:[touches anyObject]];
//    [super touchesCancelled:touches withEvent:event];
//}

@end
