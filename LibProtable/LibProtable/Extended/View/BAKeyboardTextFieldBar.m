//
//  BAKeyboardTextFieldBar.m
//  BAKeyboardTextFieldBar
//
//  Created by houzhenyong on 14-5-25.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAKeyboardTextFieldBar.h"

#define kCententViewHeight          44

#define kTextFieldLeftMargin        8
#define kTextFieldTopMargin         4
#define kButtonWidth                40
#define kTextFieldAndButtonSpace    8

@interface BAKeyboardTextFieldBar()<UITextFieldDelegate> {
}

@end

@implementation BAKeyboardTextFieldBar

+ (id)keyboardBarWithPlaceholder:(NSString *)placeholder
                        delegate:(id<BAKeyboardTextFieldBarDelegate>)delegate
{
    BAKeyboardTextFieldBar *bar = [[BAKeyboardTextFieldBar alloc] initWithPlaceholder:placeholder delegate:delegate];
    return bar;
}

- (id)initWithPlaceholder:(NSString *)placeholder delegate:(id<BAKeyboardTextFieldBarDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCententViewHeight)];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCententViewHeight)];
        _contentView.backgroundColor = [UIColor lightGrayColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_contentView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin,
                                                                   kTextFieldTopMargin,
                                                                   self.bounds.size.width - kTextFieldLeftMargin * 2 - kButtonWidth - kTextFieldAndButtonSpace,
                                                                   self.bounds.size.height - kTextFieldTopMargin * 2)];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = placeholder;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.delegate = self;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_contentView addSubview:_textField];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - kTextFieldLeftMargin - kButtonWidth,
                                                                      0,
                                                                      kButtonWidth,
                                                                      self.bounds.size.height)];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(onSendAction) forControlEvents:UIControlEventTouchUpInside];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _sendButton = button;
        [_contentView addSubview:_sendButton];
        
        self.backgroundColor = [UIColor clearColor];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return self;
}

- (void)showInView:(UIView*)view
{
    UIWindow *window = view.window;
    self.frame = window.frame;
    [window addSubview:self];
    
    [self monitorKeyboardEvent];
    [_textField becomeFirstResponder];
}

- (void)dismiss
{
    _textField.text = @"";
    [_textField resignFirstResponder];
}

- (void)onSendAction
{
    [self.delegate sendTextForKeyboardWithTextFieldBar:_textField.text];
    [self dismiss];
}

- (void)dealloc
{
    [self removeKeyboardEventMonitor];
}

- (void)monitorKeyboardEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [_textField resignFirstResponder];
}

- (void)removeKeyboardEventMonitor
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    NSValue* beginValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardBeginRect = [beginValue CGRectValue];
//    keyboardBeginRect = [_superView convertRect:keyboardBeginRect fromView:nil];
    
    NSValue* endValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndRect = [endValue CGRectValue];
//    keyboardEndRect = [_superView convertRect:keyboardEndRect fromView:nil];

    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    [_contentView setTop:(keyboardBeginRect.origin.y - kCententViewHeight)];

    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];

        [_contentView setTop:(keyboardEndRect.origin.y - kCententViewHeight)];
    } completion:^(BOOL finished) {
    }];
    
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // 获得键盘信息
    NSValue* beginValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardBeginRect = [beginValue CGRectValue];
//    keyboardBeginRect = [_superView convertRect:keyboardBeginRect fromView:nil];
    
    NSValue* endValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndRect = [endValue CGRectValue];
//    keyboardEndRect = [_superView convertRect:keyboardEndRect fromView:nil];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [_contentView setTop:(keyboardBeginRect.origin.y - kCententViewHeight)];

    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        [_contentView setTop:(keyboardEndRect.origin.y - kCententViewHeight)];
    } completion:^(BOOL finished) {
        [self removeKeyboardEventMonitor];
        [self removeFromSuperview];
    }];
    
    [self removeGestureRecognizer:_tapGestureRecognizer];
}

#pragma mark- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onSendAction];
    return YES;
}

@end
