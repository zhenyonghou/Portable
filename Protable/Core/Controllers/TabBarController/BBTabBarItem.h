//
//  BBTabBarButton.h
//
//  Created by zhenyonghou on 15/6/27.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BBTabBarItemViewState) {
    BBTabBarItemViewStateNormal,
    BBTabBarItemViewStateSelected
};

@interface BBTabBarItem : UIView {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
    NSDictionary *_attributedNormal;
    NSDictionary *_attributedSelected;
}


@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *selectedImage;


@property (nonatomic, assign) CGFloat innerSpacing;

@property (nonatomic, assign, getter=isSelected) BOOL selected;


- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

- (void)setTitleTextAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(BBTabBarItemViewState)state;

@end
