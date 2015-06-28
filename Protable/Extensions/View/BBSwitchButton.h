//
//  SFSwitchButton.h
//  SFBestIphone
//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BASwitchButtonState) {
    BASwitchButtonStateOff  = 0,
    BASwitchButtonStateOn
};

@interface BBSwitchButton : UIButton {
@protected
    __weak id _target;
    SEL _switchAction;
    
    UIImage *_offImage;
    UIImage *_onImage;
}

/**
 *  为YES时，touchUpInsideAction不改变状态
 */
@property (nonatomic, assign) BOOL manualSwitch;   // default is NO

//@property (nonatomic, assign) BOOL bounceAnimate;       // default is NO

@property (nonatomic, assign) BOOL ignoreTouch;

@property (nonatomic, assign) BASwitchButtonState switchState;


- (id)initWithFrame:(CGRect)frame offImage:(UIImage*)offImage onImage:(UIImage*)onImage;

- (void)setOffImage:(UIImage*)offImage onImage:(UIImage*)onImage;

- (void)addTarget:(id)target switchAction:(SEL)action;

/*
 * 手动选择时候调用，可以设置是否动画
 */
//- (void)setSwitchState:(BASwitchButtonState)switchState animated:(BOOL)animated;


@end