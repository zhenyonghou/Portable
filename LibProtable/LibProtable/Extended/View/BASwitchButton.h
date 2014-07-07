//
//  SFSwitchButton.h
//  SFBestIphone
//
//  Created by hou zhenyong on 14-2-9.
//  Copyright (c) 2014年 sfbest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BASwitchButton : UIButton {
@protected
    __weak id _target;
    SEL _touchedSelector;

    UIImage *_offImage;
    UIImage *_onImage;
}

@property (nonatomic, assign) BOOL stateOn;

@property (nonatomic, assign) BOOL bounceAnimate;       // default is NO

- (id)initWithFrame:(CGRect)frame
           offImage:(UIImage*)offImage
            onImage:(UIImage*)onImage
             target:(id)target
           selector:(SEL)selector;

- (void)setOffImage:(UIImage*)offImage onImage:(UIImage*)onImage;

@end
