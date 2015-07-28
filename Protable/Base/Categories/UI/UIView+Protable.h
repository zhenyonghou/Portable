//  UIDevice+BAAdditions.h
//  Created by hou zhenyong on 13-12-13.

#import <UIKit/UIKit.h>

@interface UIView (Protable)

@property (nonatomic) CGFloat mm_left;

@property (nonatomic) CGFloat mm_top;

@property (nonatomic) CGFloat mm_right;

@property (nonatomic) CGFloat mm_bottom;

@property (nonatomic) CGFloat mm_width;

@property (nonatomic) CGFloat mm_height;

@property (nonatomic) CGFloat mm_centerX;

@property (nonatomic) CGFloat mm_centerY;

@property (nonatomic) CGPoint mm_origin;

@property (nonatomic) CGSize mm_size;

/**
 设左上角坐标
 */
- (void)mm_setLeft:(CGFloat)left top:(CGFloat)top;

/**
 设左下角坐标
 */
- (void)mm_setLeft:(CGFloat)left bottom:(CGFloat)bottom;

/**
 设右上角坐标
 */
- (void)mm_setRight:(CGFloat)right top:(CGFloat)top;

/**
 设右下角坐标
 */
- (void)mm_setRight:(CGFloat)right bottom:(CGFloat)bottom;

- (void)removeAllSubviews;

@end
