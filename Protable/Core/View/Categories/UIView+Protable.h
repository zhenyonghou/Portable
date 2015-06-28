//  UIDevice+BAAdditions.h
//  Created by hou zhenyong on 13-12-13.

#import <UIKit/UIKit.h>

@interface UIView (Protable)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

/**
 设左上角坐标
 */
- (void)setLeft:(CGFloat)left top:(CGFloat)top;

/**
 设左下角坐标
 */
- (void)setLeft:(CGFloat)left bottom:(CGFloat)bottom;

/**
 设右上角坐标
 */
- (void)setRight:(CGFloat)right top:(CGFloat)top;

/**
 设右下角坐标
 */
- (void)setRight:(CGFloat)right bottom:(CGFloat)bottom;

- (void)removeAllSubviews;

@end
