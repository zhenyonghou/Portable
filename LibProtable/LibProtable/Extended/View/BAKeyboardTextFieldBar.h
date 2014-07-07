//
//  BAKeyboardTextFieldBar.h
//  BAKeyboardTextFieldBar
//
//  Created by houzhenyong on 14-5-25.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BAKeyboardTextFieldBarDelegate;

@interface BAKeyboardTextFieldBar : UIView {
    UITextField *_textField;
    UIButton *_sendButton;
    UIView *_contentView;
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@property (nonatomic, weak)id<BAKeyboardTextFieldBarDelegate> delegate;

+ (id)keyboardBarWithPlaceholder:(NSString *)placeholder
                        delegate:(id<BAKeyboardTextFieldBarDelegate>)delegate;

- (id)initWithPlaceholder:(NSString *)placeholder delegate:(id<BAKeyboardTextFieldBarDelegate>)delegate;

- (void)showInView:(UIView*)view;

- (void)dismiss;

@end

@protocol BAKeyboardTextFieldBarDelegate <NSObject>

- (void)sendTextForKeyboardWithTextFieldBar:(NSString*)text;

@end
