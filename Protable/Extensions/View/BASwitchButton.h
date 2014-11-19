//
//  SFSwitchButton.h
//  SFBestIphone
//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BASwitchButton : UIButton {
@protected
    __weak id _target;
    SEL _switchAction;
    
    UIImage *_normalImage;
    UIImage *_selectedImage;
}

@property (nonatomic, assign) BOOL bounceAnimate;       // default is NO

- (id)initWithFrame:(CGRect)frame
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage
             target:(id)target
       switchAction:(SEL)action;

- (id)initWithFrame:(CGRect)frame normalImage:(UIImage*)normalImage selectedImage:(UIImage*)selectedImage;

- (void)setNormalImage:(UIImage*)normalImage selectedImage:(UIImage*)selectedImage;

- (void)addTarget:(id)target switchAction:(SEL)action;

@end
