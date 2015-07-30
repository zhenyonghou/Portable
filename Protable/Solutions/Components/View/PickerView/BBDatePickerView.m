//
//  BADatePickerView.m
//  Adult
//
//  Created by houzhenyong on 14-7-27.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBDatePickerView.h"

@interface BBDatePickerView ()

@property (nonatomic, weak) id<BBDatePickerViewDelegate> delegate;

@end

@implementation BBDatePickerView

- (id)initWithDelegate:(id<BBDatePickerViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT - PHONE_STATUSBAR_HEIGHT)]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 初始化bar
        UIBarButtonItem *canceItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"取消")
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(btnCancelClick)];
        
        NSString *doneTitle = NSLocalizedString(@"完成", @"完成");
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:doneTitle
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(btnDoneClick)];
        UIBarButtonItem *flexibleSpaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *buttons = [NSArray arrayWithObjects:canceItem, flexibleSpaceBarItem, doneItem, nil];
        
        // 为子视图构造工具栏
        UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                       self.frame.size.height - (PHONE_KEYBOARD_HEIGHT+PHONE_TOOLBAR_HEIGHT),
                                                                       self.frame.size.width,
                                                                       PHONE_TOOLBAR_HEIGHT)];
        toolBar.backgroundColor = [UIColor blackColor];
        toolBar.barStyle = UIBarStyleBlack;
        toolBar.translucent = YES;
        [toolBar sizeToFit];
        [toolBar setAlpha:0.7];
        [toolBar setItems:buttons animated:YES];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
        // 初始化pickerView控件
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                                  self.frame.size.height - PHONE_KEYBOARD_HEIGHT,
                                                                                  self.frame.size.width,
                                                                                  PHONE_KEYBOARD_HEIGHT)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:datePicker];
        self.pickerView = datePicker;
        self.delegate = delegate;
        
        _isShowing = NO;
    }
    
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.pickerView.date = _date;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    self.pickerView.minimumDate = _minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    self.pickerView.maximumDate = _maximumDate;
}

- (void)btnDoneClick {
    [self.delegate confirmDatePickerView:self];
}

- (void)btnCancelClick{
    if ([self.delegate respondsToSelector:@selector(cancelDatePickerView:)]) {
        [self.delegate cancelDatePickerView:self];
    }
    [self hidePickerWithAnimation];
}


#pragma mark- animation

- (void)showInView:(UIView *)view
{
    if (_isShowing) {
        return;
    }
    _isShowing = YES;
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hidePickerWithAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         _isShowing = NO;
                     }];
}

@end
