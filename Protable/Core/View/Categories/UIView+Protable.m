//  UIDevice+UIDeviceExt.h
//  Created by hou zhenyong on 13-12-13.

#import "UIView+Protable.h"

@implementation UIView (Protable)

- (CGFloat)mm_left {
    return self.frame.origin.x;
}

- (void)setMm_left:(CGFloat)mm_left {
    CGRect frame = self.frame;
    frame.origin.x = mm_left;
    self.frame = frame;
}

- (CGFloat)mm_top {
    return self.frame.origin.y;
}

- (void)setMm_top:(CGFloat)mm_top {
    CGRect frame = self.frame;
    frame.origin.y = mm_top;
    self.frame = frame;
}

- (CGFloat)mm_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMm_right:(CGFloat)mm_right {
    CGRect frame = self.frame;
    frame.origin.x = mm_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mm_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMm_bottom:(CGFloat)mm_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mm_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mm_centerX {
    return self.center.x;
}

- (void)setMm_centerX:(CGFloat)mm_centerX {
    self.center = CGPointMake(mm_centerX, self.center.y);
}

- (CGFloat)mm_centerY {
    return self.center.y;
}

- (void)setMm_centerY:(CGFloat)mm_centerY {
    self.center = CGPointMake(self.center.x, mm_centerY);
}

- (CGFloat)mm_width {
    return self.frame.size.width;
}

- (void)setMm_width:(CGFloat)mm_width {
    CGRect frame = self.frame;
    frame.size.width = mm_width;
    self.frame = frame;
}

- (CGFloat)mm_height {
    return self.frame.size.height;
}

- (void)setMm_height:(CGFloat)mm_height {
    CGRect frame = self.frame;
    frame.size.height = mm_height;
    self.frame = frame;
}

- (CGPoint)mm_origin {
    return self.frame.origin;
}

- (void)setMm_origin:(CGPoint)mm_origin {
    CGRect frame = self.frame;
    frame.origin = mm_origin;
    self.frame = frame;
}

- (CGSize)mm_size {
    return self.frame.size;
}

- (void)setMm_size:(CGSize)mm_size {
    CGRect frame = self.frame;
    frame.size = mm_size;
    self.frame = frame;
}

- (void)mm_setLeft:(CGFloat)left top:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)mm_setLeft:(CGFloat)left bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)mm_setRight:(CGFloat)right top:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)mm_setRight:(CGFloat)right bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end


