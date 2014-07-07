//  UIDevice+BAAdditions.h
//  Created by hou zhenyong on 13-12-13.

#import <UIKit/UIKit.h>

@interface UIView (BAAdditions)

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


- (void)removeAllSubviews;

@end
