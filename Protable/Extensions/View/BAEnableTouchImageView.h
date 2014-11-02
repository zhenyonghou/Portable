//
//  BAEnableTouchImageView.h
//  
//
//  Created by hou zhenyong on 14-3-31.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BAEnableTouchImageViewDelegate;

/**
 可点击的imageView，使用touchesBegan等函数实现的话，在某些情况无法达到效果，
 比如：在父View加了手势的时候。
 所以，弃掉touchesBegan函数，使用了手势响应
 */

@interface BAEnableTouchImageView : UIImageView {
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@property (nonatomic, weak) id<BAEnableTouchImageViewDelegate> delegate;

@end

@protocol BAEnableTouchImageViewDelegate <NSObject>

//- (void)touchImageView:(BAEnableTouchImageView *)imageView touch:(UITouch*)touch;

- (void)touchImageView:(BAEnableTouchImageView *)imageView;

@end